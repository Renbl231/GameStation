const db = require('../config/db')
const bcrypt = require('bcryptjs')

class UserService {
    static async getUserByNickname(nickname) {
        const [result] = await db.execute(
            'SELECT idUser, nickname, avatar_url, banner_url FROM Users WHERE nickname = ?', [nickname]
        )
        if(result.length === 0) {
            throw {message: 'Пользователь не найден', status: 404}
        }
        return result[0]
    }

    static async editUserData(newNickname, avatar, banner, password, user_id, nickname) {
        const [existUser] = await db.execute(
            'SELECT idUser FROM Users WHERE nickname = ?', [nickname]
        )
        if(existUser.length === 0) {
            throw {status: 404, message:'Пользователь не найден'}
        }
        if(existUser[0].idUser !== user_id) {
            throw {status: 403, message:'Ошибка доступа'}
        }

        const setFields = []
        const values = []

        if(newNickname && newNickname.length >= 5) {
            setFields.push('nickname = ?')
            values.push(newNickname)
        }
        
        if (avatar && avatar.length > 0) {
            setFields.push('avatar_url = ?')
            values.push(avatar)
        }
        
        if (banner && banner.length > 0) {
            setFields.push('banner_url = ?')
            values.push(banner)
        }

        if (password && password.length >= 6) {
            const hashPassword = await bcrypt.hash(password, 10)
            setFields.push('password = ?')
            values.push(hashPassword)
        } 

        if (setFields.length === 0) {
            throw {status: 400, message: 'Нет данных для обновления'}
        }

        values.push(user_id)

        const [result] = await db.execute(
            `UPDATE Users SET ${setFields.join(', ')} WHERE idUser = ?`,
            values
        )
        
        if (result.affectedRows === 0) {
            throw new Error('Ошибка обновлении данных')
        }
    
        const [updatedUser] = await db.execute(
            'SELECT idUser, nickname, avatar_url, banner_url FROM Users WHERE idUser = ?',
            [user_id]
        )
        
        return {
            user: updatedUser[0],
            message: 'Данные успешно отредактированы'
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

}


module.exports = UserService