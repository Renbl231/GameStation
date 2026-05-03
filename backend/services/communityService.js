const db = require('../config/db')

class CommunityService {
    static async getDiscussionsByPage(page = 1, limit = 20, sort = null, sectionId = null, userId = null) {
  const safePage = Math.max(1, parseInt(page))
  const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
  const offset = (safePage - 1) * safeLimit

  let whereClause = `WHERE q.moderated_status = 'active'`
  const baseParams = []

  if (sort === 'closed') {
    whereClause += ' AND q.status = ?'
    baseParams.push('closed')
  } else {
    whereClause += ' AND q.status = ?'
    baseParams.push('open')
  }

  if (sectionId && sectionId !== 6 && sectionId !== 13) {
    whereClause += ' AND q.section_id = ?'
    baseParams.push(sectionId)
  }

  if (sectionId === 13 && userId) {
    whereClause += ' AND q.user_id = ?'
    baseParams.push(userId)
  }

  const myCountResult = userId
    ? await db.query(
        `SELECT COUNT(*) as total FROM Questions q WHERE q.moderated_status = 'active' AND q.user_id = ?`,
        [userId]
      )
    : [[{ total: 0 }]]

  const [countResult, discussionsResult] = await Promise.all([
    db.query(`SELECT COUNT(*) as total FROM Questions q ${whereClause}`, baseParams),
    db.query(`
      SELECT 
        q.idQuestion,
        q.title,
        q.description,
        q.comments_count,
        q.status,
        q.created_at,
        q.user_id,
        u.idUser,
        u.nickname,
        u.avatar_url
      FROM Questions q
      LEFT JOIN Users u ON q.user_id = u.idUser
      ${whereClause}
      ORDER BY q.created_at DESC
      LIMIT ${safeLimit} OFFSET ${offset}
    `, baseParams)
  ])

  const [{ total }] = countResult[0]
  const [discussions] = discussionsResult
  const [{ total: myTotal }] = myCountResult[0]

  return {
    discussions: discussions.map(row => ({
      idQuestion: row.idQuestion,
      title: row.title,
      description: row.description,
      status: row.status,
      comments_count: row.comments_count,
      created_at: row.created_at,
      user: {
        nickname: row.nickname,
        avatar_url: row.avatar_url
      }
    })),
    totalPages: Math.ceil(total / safeLimit),
    currentPage: safePage,
    perPage: safeLimit,
    myTotalQuestions: myTotal
  }
}


   

    static async createTheme(title, description, section_id, user_id) {
        const [restriction] = await db.execute(
            `SELECT id
            FROM UserRestrictions
            WHERE user_id = ?
                AND restriction_type = 'question'
                AND banned_until > NOW()
            LIMIT 1`,
            [user_id]
        )

        if (restriction.length) {
            throw { message: 'Вы заблокированы для вопросов', status: 403}
        }

        await db.execute(
            'INSERT INTO Questions (title, description, section_id, user_id) VALUES(?,?,?,?)',
            [title, description, section_id, user_id]
        )
        return true
    }

    static async getTheme(id, incrementView = false) {
        if (incrementView) {
            await db.execute(
                'UPDATE Questions SET views_count = views_count + 1 WHERE idQuestion = ?', 
                [id]
            )
        }
        
        const [theme] = await db.execute(
            `SELECT 
                q.*, 
                u.idUser,
                u.nickname, 
                u.avatar_url
            FROM Questions q
            LEFT JOIN Users u ON q.user_id = u.idUser
            WHERE q.idQuestion = ? AND q.moderated_status = 'active'`, 
            [id]
        )
        
        return theme[0]
    }


    static async deleteTheme(idTheme, author_id) {
        const [result] = await db.execute(
            `DELETE FROM Questions
            WHERE idQuestion = ? AND user_id = ?`,
            [idTheme, author_id]
        )
        
        if(result.affectedRows === 0) {
            throw {status: 404, message: 'Новость не найдена или нет прав на удаление'}
        }
        
        return true
    }

    static async updateTheme(id, title, category, description, user_id) {
        const [restriction] = await db.execute(
            `SELECT id
            FROM UserRestrictions
            WHERE user_id = ?
                AND restriction_type = 'question'
                AND banned_until > NOW()
            LIMIT 1`,
            [user_id]
        )

        if (restriction.length) {
            throw { message: 'Вы заблокированы для вопросов', status: 403}
        }


        const [result] = await db.execute(
            `UPDATE Questions 
            SET title = ?, description = ?, section_id = ?
            WHERE idQuestion = ? AND user_id = ?`,
            [title, description, category,id, user_id]
        )
        
        if(result.affectedRows === 0) {
            throw {status: 404, message: 'Новость не найдена или нет прав на редактирование'}
        }
        
        return true
    }


}

module.exports = CommunityService
