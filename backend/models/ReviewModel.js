const db = require("../config/db");

const ReviewModel = {
    queryAsync(sql, params){
        return new Promise((resolve, reject) => {
            db.query(sql, params, (err, results) => {
                if(err) return reject(err);
                resolve(results);
            });
        });
    },

    async getBookReviews(bookId) {
        const query = `
            SELECT
                r.review_id,
                r.rating,
                r.comment,
                r.created_at,
                u.name
            FROM reviews r
            JOIN users u
                ON r.user_id = u.id
            WHERE r.book_id = ?
            ORDER BY r.created_at DESC
        `;
        const rows = await this.queryAsync(query, [bookId]);
        return rows;
    },

    async getReviewSummary(bookId){
        const query = `
            SELECT
                ROUND(AVG(rating),1) AS average_rating,
                COUNT(*) AS total_review
            FROM reviews
            WHERE book_id = ?
        `;
        const rows = await this.queryAsync(query, [bookId]);
        return rows[0];
    },

    async getUserReview(userId, bookId){
        const query = `
            SELECT *
            FROM reviews
            WHERE user_id = ?
            AND book_id = ?
        `;
        const rows = await this.queryAsync(query, [userId, bookId]);
        return rows[0];
    },

    async createReview(userId, bookId, rating, comment){
        const query = `
            INSERT INTO reviews
            (user_id, book_id, rating, comment)
            VALUES(?,?,?,?)
        `;
        const result = await this.queryAsync(query, [userId, bookId, rating, comment]);
        return result;
    },

    async updateReview(reviewId, rating, comment){
        const query = `
            UPDATE reviews
            SET
                rating=?,
                comment=?
            WHERE review_id=?
        `;
        const result = await this.queryAsync(query, [rating, comment, reviewId]);
        return result;
    }
};

module.exports = ReviewModel;