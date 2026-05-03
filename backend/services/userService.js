const db = require('../config/db')
const bcrypt = require('bcryptjs')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('./storageService')

class UserService {
    static async getUserByNickname(nickname) {
        const [result] = await db.execute(
            'SELECT idUser, nickname, avatar_url, banner_url FROM Users WHERE nickname = ?', [nickname]
        )
        if(result.length === 0) {
            throw {message: 'Пользователь не найден', status: 404}
        }

        const user = result[0]

        return {
            ...user,
            avatar_url: user.avatar_url ? getPublicMinioUrl(user.avatar_url) : null,
            banner_url: user.banner_url ? getPublicMinioUrl(user.banner_url) : null,
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


    static async editUserAvatar(user_id, avatar) {
        if (!avatar) {
            throw { status: 400, message: 'Файл не передан' }
        }

        const [userRows] = await db.execute(
            'SELECT avatar_url FROM Users WHERE idUser = ?',
            [user_id]
        )

        if (userRows.length === 0) {
            throw { status: 404, message: 'Пользователь не найден' }
        }

        const oldAvatar = userRows[0].avatar
        const uploaded = await StorageService.uploadAvatarToBucket(avatar)

        const [result] = await db.execute(
            'UPDATE Users SET avatar_url = ? WHERE idUser = ?',
            [uploaded.key, user_id]
        )

        if (result.affectedRows === 0) {
            throw new Error('Ошибка обновления аватара')
        }

        if (oldAvatar) {
            await StorageService.deleteAvatarFromBucket(oldAvatar)
        }

        return {
            avatar: uploaded.key
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

        const total = countRows[0].total

        const [rows] = await db.execute(
            `
            SELECT
            r.idReview,
            r.title,
            r.content,
            r.created_at,
            gm.idGame,
            gm.name,
            gm.cover_url,
            gr.overall_score
            FROM Reviews r
            LEFT JOIN Games gm ON gm.idGame = r.game_id
            LEFT JOIN GameRatings gr ON gr.user_id = r.user_id
            AND gr.game_id = r.game_id
            WHERE r.user_id = ?
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




// потом стереть

    static async insertPhoto(userId, file) {
        const [rows] = await db.execute(
            'SELECT avatar_url FROM Users WHERE idUser = ?',
            [userId]
        )

        const oldAvatar = rows[0]?.avatar_url || null
        const objectName = `avatars/${userId}-${Date.now()}-${file.originalname}`

        await minioClient.putObject(
            'gamestation-media',
            objectName,
            file.buffer,
            file.size,
            { 'Content-Type': file.mimetype }
        )

        await db.execute(
            'UPDATE Users SET avatar_url = ? WHERE idUser = ?',
            [objectName, userId]
        )

        if (oldAvatar && oldAvatar !== objectName) {
            await minioClient.removeObject('gamestation-media', oldAvatar)
        }

        return true
    }
















}


module.exports = UserService