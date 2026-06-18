const db = require('../config/db');

const LoanModel = {
    createLoan: (userId, bookId) => {
        return db.promise().query(
            "INSERT INTO loans (user_id, book_id) VALUES (?, ?)", 
            [userId, bookId]
        );
    },

    returnLoan: (loanId) => {
        return db.promise().query(
            "UPDATE loans SET status = 'returned', return_date = NOW() WHERE id = ?", 
            [loanId]
        );
    },

    findActiveLoan: (userId, bookId) => {
        return db.promise().query(
            "SELECT * FROM loans WHERE user_id = ? AND book_id = ? AND status = 'borrowed'", 
            [userId, bookId]
        );
    },

    getUserLoans: (userId) => {
        return db.promise().query(
            `SELECT l.id, l.book_id, l.borrow_date, l.return_date, l.status, b.title, b.author 
             FROM loans l 
             JOIN books b ON l.book_id = b.id 
             WHERE l.user_id = ? 
             ORDER BY l.borrow_date DESC`,
            [userId]
        );
    }
};

module.exports = LoanModel;