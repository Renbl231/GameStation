const db = require('../config/db')
const bcrypt = require('bcryptjs')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('./storageService')

class UserService {
    static async getUserByNickname(nickname) {
        const [result] = await db.execute(
            'SELECT idUser, nickname, avatar_url, banner_url FROM Users WHERE nickname = ?', 
            [nickname]
        )

        if(result.length === 0) {
            throw {message: 'Пользователь не найден', status: 404}
        }

        const userId = result[0].idUser
        const user = result[0]

        const [favoriteGames, currentGames] = await Promise.all([
            db.execute(`
                SELECT uc.collection_type, gm.idGame, gm.name, gm.cover_url, gr.overall_score
                FROM UserCollections uc
                LEFT JOIN Games gm ON gm.idGame = uc.game_id
                LEFT JOIN GameRatings gr ON gr.user_id = ? AND gr.game_id = uc.game_id
                WHERE uc.user_id = ? AND uc.collection_type = 'Любимые'
                ORDER BY uc.created_at DESC LIMIT 10
            `, [userId, userId]),

            db.execute(`
                SELECT uc.collection_type, gm.idGame, gm.name, gm.cover_url, gr.overall_score
                FROM UserCollections uc
                LEFT JOIN Games gm ON gm.idGame = uc.game_id
                LEFT JOIN GameRatings gr ON gr.user_id = ? AND gr.game_id = uc.game_id
                WHERE uc.user_id = ? AND uc.collection_type = 'Сейчас играю'
                ORDER BY uc.created_at DESC LIMIT 10
            `, [userId, userId])
        ])

        const games = [...favoriteGames[0], ...currentGames[0]]  // 👈 [0] т.к. db.execute

        return {
            ...user,
            avatar_url: user.avatar_url ? getPublicMinioUrl(user.avatar_url) : null,
            banner_url: user.banner_url ? getPublicMinioUrl(user.banner_url) : null,
            games
        }
    }

    static async editUserData(nickname, password, user_id) {
        const setFields = []
        const values = []

        const currentNickname = nickname?.trim()

        if (currentNickname && currentNickname.length >= 5) {
            setFields.push('nickname = ?')
            values.push(currentNickname)
        }

        if (password && password.trim().length >= 6) {
            const hashPassword = await bcrypt.hash(password.trim(), 10)
            setFields.push('password = ?')
            values.push(hashPassword)
        }

        if (setFields.length === 0) {
            throw { status: 400, message: 'Нет данных для обновления' }
        }

        values.push(user_id)

        const [result] = await db.execute(
            `UPDATE Users SET ${setFields.join(', ')} WHERE idUser = ?`,
            values
        )

        if (result.affectedRows === 0) {
            throw new Error('Ошибка обновления данных')
        }

        return {
            user: {
                nickname: currentNickname
            }
        }
    }


    static async editUserImage(user_id, file, type) {
        if (!file) {
            throw { status: 400, message: 'Файл не передан' }
        }

        if (!file.mimetype.startsWith('image/')) {
            throw { status: 400, message: 'Только изображения' }
        }
        
        const field = type === 'avatar' ? 'avatar_url' : 'banner_url'
        const bucketFolder = type === 'avatar' ? 'avatars' : 'banners'

        const [userRows] = await db.execute(
            `SELECT ${field} FROM Users WHERE idUser = ?`,
            [user_id]
        )
        
        if (userRows.length === 0) {
            throw { status: 404, message: 'Пользователь не найден' }
        }

        const oldImage = userRows[0][field]
        const uploaded = await StorageService.uploadFileToBucket(file, bucketFolder)

        const [result] = await db.execute(
            `UPDATE Users SET ${field} = ? WHERE idUser = ?`,
            [uploaded.key, user_id]
        )

        if (oldImage) {
            await StorageService.deleteFileFromBucket(oldImage)
        }

        return {
            [`${type}_url`]: getPublicMinioUrl(uploaded.key) || null
        }
    }













   static async getUserGames(userId, page = 1, limit = 20) {
  const safePage = Math.max(1, parseInt(page))
  const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
  const offset = (safePage - 1) * safeLimit

  const [countRows] = await db.execute(
    `SELECT COUNT(*) as total FROM UserCollections WHERE user_id = ?`,
    [userId]
  )

  const total = countRows[0].total

  const [rows] = await db.execute(
    `
    SELECT
      uc.game_id,
      uc.collection_type,
      gm.idGame,
      gm.name,
      gm.cover_url,
      gr.overall_score
    FROM UserCollections uc
    LEFT JOIN Games gm
      ON gm.idGame = uc.game_id
    LEFT JOIN GameRatings gr
      ON gr.user_id = uc.user_id
     AND gr.game_id = uc.game_id
    WHERE uc.user_id = ?
    LIMIT ${safeLimit} OFFSET ${offset}
    `,
    [userId]
  )

  return {
    rows,
    totalPages: Math.ceil(total / safeLimit),
    currentPage: safePage,
    perPage: safeLimit
  }
}



static async getUserReviews(userId, page = 1, limit = 20) {
    const safePage = Math.max(1, parseInt(page))
    const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
    const offset = (safePage - 1) * safeLimit


    const [countRows] = await db.execute(
        `SELECT COUNT(*) as total FROM Reviews WHERE user_id = ?`,
        [userId]
    )
    const total = parseInt(countRows[0]?.total || 0)

    const [rows] = await db.execute(
        `SELECT r.idReview, r.title, r.content, r.created_at,
                gm.idGame, gm.name, gm.cover_url, gr.overall_score
        FROM Reviews r
        LEFT JOIN Games gm ON gm.idGame = r.game_id
        LEFT JOIN GameRatings gr ON gr.user_id = r.user_id 
        AND gr.game_id = r.game_id
        WHERE r.user_id = ?
        ORDER BY r.created_at DESC
        LIMIT ${safeLimit} OFFSET ${offset}`,
        [userId] 
    )

    return {
        reviews: rows,
        totalPages: Math.ceil(total / safeLimit),
        currentPage: safePage,
        perPage: safeLimit,
        total
    }
}

    static async banUser(type, user_id, banDays, reason, moderator_id, entity_id) {
        const [existing] = await db.execute(
            `SELECT id
            FROM UserRestrictions
            WHERE user_id = ?
            AND restriction_type = ?
            AND banned_until > NOW()
            LIMIT 1`,
            [user_id, type]
        )

        if (existing.length) {
            throw { success: false, message: 'Пользователь уже заблокирован' }
        }

        const bannedUntil = new Date()
        bannedUntil.setDate(bannedUntil.getDate() + Number(banDays))

        await db.execute(
            `INSERT INTO UserRestrictions
            (user_id, restriction_type, banned_until, moderation_reason, moderated_by)
            VALUES (?, ?, ?, ?, ?)`,
            [user_id, type, bannedUntil, reason, moderator_id]
        )

        if(type === 'review') {
            await db.execute(
                `UPDATE Reviews SET moderated_status = 'hidden'
                 WHERE idReview = ?`,
                [entity_id]
            )
        } else if(type === 'comment') {
            await db.execute(
                `UPDATE Comments SET moderated_status = 'hidden'
                WHERE idComment = ?`,
                [entity_id]
            )
        } else if(type === 'question') {
            await db.execute(
                `UPDATE Questions SET moderated_status = 'hidden'
                WHERE idQuestion = ?`,
                [entity_id]
            )
        }

        return { success: true, message: 'Пользователь заблокирован' }

    }






       static async getUserComments(userId, page = 1, limit = 20, status) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit

        const [countRows] = await db.execute(
            `SELECT COUNT(*) as total FROM Comments WHERE user_id = ? AND moderated_status = ?`,
            [userId, status]
        )

        const total = countRows[0].total

        const [comments] = await db.execute(
            `
            SELECT
            c.idComment, c.content, c.created_at
            FROM Comments c
            WHERE user_id = ? AND moderated_status = ?
            LIMIT ${safeLimit} OFFSET ${offset}
            `,
            [userId, status]
        )

            return {
                comments,
                totalPages: Math.ceil(total / safeLimit),
                currentPage: safePage,
                perPage: safeLimit
            }
        }

        static async getUserRequests(user_id) {
            const [siteResult, gameResult] = await Promise.all([
                db.execute(`
                    SELECT q.title, q.description, q.status, q.notes, q.created_at, 
                        qs.name AS section_name
                    FROM Questions q
                    LEFT JOIN QuestionSections qs ON qs.idSection = q.section_id
                    WHERE q.section_id IN (1, 2, 3, 5) 
                        AND q.user_id = ?
                    ORDER BY q.created_at DESC
                `, [user_id]),

                db.execute(`
                    SELECT gr.*, u.nickname AS moderator, u.avatar_url AS moderator_avatar 
                    FROM GameRequests gr
                    LEFT JOIN Users u ON u.idUser = gr.moderator_id
                    WHERE gr.user_id = ?
                    ORDER BY gr.created_at DESC
                `, [user_id])
            ])

            const siteRequestRaw = siteResult[0]  
            const gameRequestsRaw = gameResult[0]

            const gameRequests = gameRequestsRaw.map(req => ({
                ...req,
                moderator_avatar: req.moderator_avatar 
                    ? getPublicMinioUrl(req.moderator_avatar) 
                    : null
            }))

            return {
                gameRequests,
                siteRequests: siteRequestRaw
            }
        }








}


module.exports = UserService