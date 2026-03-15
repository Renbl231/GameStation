const db = require('../config/db')

class CommunityService {
    static async getDiscussionsByPage(page = 1, limit = 20, sort = null, sectionId = null) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit

        let whereClause = ''
        const baseParams = []
        
        if (sort === 'closed') {
            whereClause += 'WHERE q.status = ?'
            baseParams.push('closed')
        } else {
            whereClause += 'WHERE q.status = ?'
            baseParams.push('open')
        }
        
        if (sectionId && sectionId !== 6) {
            whereClause += whereClause ? ' AND q.section_id = ?' : 'WHERE q.section_id = ?'
            baseParams.push(sectionId)
        }
        
        const [countResult, discussionsResult] = await Promise.all([
            db.query(
                `SELECT COUNT(*) as total FROM Questions q ${whereClause}`, 
                baseParams
            ),
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
            perPage: safeLimit
        }
    }

    static async createTheme(title, description, section_id, user_id) {
        const [result] = await db.execute(
            'INSERT INTO Questions (title, description, section_id, user_id) VALUES(?,?,?,?)',
            [title, description, section_id, user_id]
        )
        return result.affectedRows > 0
    }

}

module.exports = CommunityService
