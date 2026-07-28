const db = require('../config/db')
const bcrypt = require('bcryptjs')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('./storageService')

const processGameImage = (imageUrl) => {
    if (!imageUrl) return null
    if (imageUrl.startsWith('games/')) {
        return getPublicMinioUrl(imageUrl) 
    }
    return imageUrl
}

class UserService {
    static async getUserByNickname(nickname) {
        const [result] = await db.execute(
            'SELECT idUser, nickname, avatar, banner, role_id as role FROM Users WHERE nickname = ?', 
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

        const games = [...favoriteGames[0], ...currentGames[0]].map(game => ({
            ...game,
            cover_url: processGameImage(game.cover_url)
        }))

        return {
            ...user,
            avatar: user.avatar ? getPublicMinioUrl(user.avatar) : null,
            banner: user.banner ? getPublicMinioUrl(user.banner) : null,
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

        const MAX_BYTES = 3 * 1024 * 1024
        if (file.size && file.size > MAX_BYTES) {
            throw { status: 400, message: 'Максимальный размер файла — 3 МБ' }
        }

        const [restriction] = await db.execute(
            `SELECT id
            FROM UserRestrictions
            WHERE user_id = ?
                AND restriction_type = 'profile'
                AND banned_until > NOW()
            LIMIT 1`,
            [user_id]
        )

        if (restriction.length) {
            throw { message: 'Вы заблокированы для медиа профиля', status: 403}
        }

            
        const field = type === 'avatar' ? 'avatar' : 'banner'
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
            ORDER BY 
                CASE uc.collection_type
                    WHEN 'Пройденные' THEN 1
                    WHEN 'Любимые' THEN 2
                    WHEN 'Сейчас играю' THEN 3
                    WHEN 'Заброшено' THEN 4
                    ELSE 5
                END,
                uc.created_at DESC
            LIMIT ${safeLimit} OFFSET ${offset}
            `,
            [userId]
        )

        const formattedRows = rows.map(row => ({
            ...row,
            cover_url: processGameImage(row.cover_url)
        }))

        return {
            rows: formattedRows,
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }



static async getUserReviews(userId, page = 1, limit = 20, status) {
    const safePage = Math.max(1, parseInt(page))
    const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
    const offset = (safePage - 1) * safeLimit

    const [counters] = await db.execute(
        `SELECT 
            SUM(CASE WHEN moderated_status = 'active' THEN 1 ELSE 0 END) as active_count,
            SUM(CASE WHEN moderated_status = 'hidden' THEN 1 ELSE 0 END) as hidden_count,
            COUNT(*) as total_count
        FROM Reviews 
        WHERE user_id = ?`,
        [userId]
    )

    const [countRows] = await db.execute(
        `SELECT COUNT(*) as total FROM Reviews WHERE user_id = ?`,
        [userId]
    )
    const total = parseInt(countRows[0]?.total || 0)

    const [rows] = await db.execute(
        `SELECT r.idReview, r.title, r.content, r.created_at, r.moderation_reason as reason,
                gm.idGame, gm.name, gm.cover_url, gr.overall_score
        FROM Reviews r
        LEFT JOIN Games gm ON gm.idGame = r.game_id
        LEFT JOIN GameRatings gr ON gr.user_id = r.user_id 
        AND gr.game_id = r.game_id
        WHERE r.user_id = ? AND moderated_status = ?
        ORDER BY r.created_at DESC
        LIMIT ${safeLimit} OFFSET ${offset}`,
        [userId, status] 
    )

    const formattedReviews = rows.map(review => ({
        ...review,
        cover_url: processGameImage(review.cover_url)
    }))

    return {
        reviews: formattedReviews,
        totalPages: Math.ceil(total / safeLimit),
        currentPage: safePage,
        perPage: safeLimit,
        total,
        stats: {
            active: counters[0].active_count || 0,
            hidden: counters[0].hidden_count || 0
        }
    }
}

    static async banUser(type, user_id, banDays, reason, moderator_id, entity_id = null) {
        const [active] = await db.execute(
            `SELECT id
            FROM UserRestrictions
            WHERE user_id = ?
            AND restriction_type = ?
            AND banned_until > NOW()
            LIMIT 1`,
            [user_id, type]
        )

        if (active.length) {
            throw { success: false, message: 'Пользователь уже заблокирован' }
        }

        const bannedUntil = new Date()
        bannedUntil.setDate(bannedUntil.getDate() + Number(banDays))

        const [existing] = await db.execute(
            `SELECT id
            FROM UserRestrictions
            WHERE user_id = ?
            AND restriction_type = ?`,
            [user_id, type]
        )

        if (existing.length) {
            await db.execute(
                `UPDATE UserRestrictions
                SET banned_until = ?, moderation_reason = ?, moderated_by = ?
                WHERE user_id = ? AND restriction_type = ?`,
                [bannedUntil, reason, moderator_id, user_id, type]
            )
        } else {
            await db.execute(
                `INSERT INTO UserRestrictions
                (user_id, restriction_type, banned_until, moderation_reason, moderated_by)
                VALUES (?, ?, ?, ?, ?)`,
                [user_id, type, bannedUntil, reason, moderator_id]
            )
        }

        if(type === 'review') {
            await db.execute(
                `UPDATE Reviews SET moderated_status = 'hidden', moderation_reason = ?
                WHERE idReview = ?`,
                [reason, entity_id]
            )
        } else if(type === 'comment') {
            await db.execute(
                `UPDATE Comments SET moderated_status = 'hidden' , moderation_reason = ?
                WHERE idComment = ?`,
                [reason, entity_id]
            )
        } else if(type === 'question') {
            await db.execute(
                `UPDATE Questions SET moderated_status = 'hidden' , moderation_reason = ?
                WHERE idQuestion = ?`,
                [reason, entity_id]
            )
        }

        return { success: true, message: 'Пользователь заблокирован' }
    }





        static async getUserComments(userId, page = 1, limit = 20, status) {
    const safePage = Math.max(1, parseInt(page))
    const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
    const offset = (safePage - 1) * safeLimit

    // Отдельный запрос для счётчиков
    const [counters] = await db.execute(
        `SELECT 
            SUM(CASE WHEN moderated_status = 'active' THEN 1 ELSE 0 END) as active_count,
            SUM(CASE WHEN moderated_status = 'hidden' THEN 1 ELSE 0 END) as hidden_count,
            COUNT(*) as total_count
        FROM Comments 
        WHERE user_id = ?`,
        [userId]
    )

    const [countRows] = await db.execute(
        `SELECT COUNT(*) as total FROM Comments WHERE user_id = ? AND moderated_status = ?`,
        [userId, status]
    )

    const total = countRows[0].total

    const [commentsResult] = await db.execute(`
        SELECT
            c.idComment, c.content, c.created_at, c.entity_type, c.user_id, c.moderation_reason as reason,
            c.moderated_status as status,
            u.nickname, u.avatar_url AS publisherCom_avatar,
            
            CASE 
                WHEN c.entity_type = 'news' THEN n.title
                WHEN c.entity_type = 'article' THEN ar.title
                WHEN c.entity_type = 'theme' THEN q.title
                WHEN c.entity_type = 'review' THEN r.title
            END AS entity_title,
            
            CASE 
                WHEN c.entity_type = 'news' THEN n.idNew
                WHEN c.entity_type = 'article' THEN ar.idArticle
                WHEN c.entity_type = 'theme' THEN q.idQuestion
                WHEN c.entity_type = 'review' THEN r.idReview
            END AS entity_id
            
            FROM Comments c
            LEFT JOIN Users u ON u.idUser = c.user_id
            
            LEFT JOIN News n ON c.entity_type = 'news' AND c.entity_id = n.idNew
            LEFT JOIN Articles ar ON c.entity_type = 'article' AND c.entity_id = ar.idArticle
            LEFT JOIN Questions q ON c.entity_type = 'theme' AND c.entity_id = q.idQuestion
            LEFT JOIN Reviews r ON c.entity_type = 'review' AND c.entity_id = r.idReview
            
            WHERE c.user_id = ? AND c.moderated_status = ?
            ORDER BY c.created_at DESC
            LIMIT ${safeLimit} OFFSET ${offset}
        `, [userId, status]
    )

    const comments = commentsResult.map(req => ({
        ...req,
        publisherCom_avatar: req.publisherCom_avatar 
            ? getPublicMinioUrl(req.publisherCom_avatar) 
            : null
    }))

    return {
        comments,
        totalPages: Math.ceil(total / safeLimit),
        currentPage: safePage,
        perPage: safeLimit,
        stats: {
            active: counters[0].active_count || 0,
            hidden: counters[0].hidden_count || 0
        }
    }
}



        static async getUserRequests(user_id) {
            const [siteResult, gameResult] = await Promise.all([
                db.execute(`
                    SELECT q.idQuestion, q.title, q.description, q.status, q.notes, q.created_at, 
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