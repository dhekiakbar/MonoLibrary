const db = require('../config/db');
const LoanModel = require('../models/LoanModel');
const BookModel = require('../models/BookModel');

// 1. Member Request Pinjam (Status jadi 'pending')
exports.borrowBook = async (req, res) => {
    try {
        const { bookId } = req.body;
        const userId = req.user.id;

        // Cek Stok
        const [books] = await BookModel.getBookById(bookId);
        if (books.length === 0) return res.status(404).json({ message: "Book not found" });
        if (books[0].stock <= 0) return res.status(400).json({ message: "Out of stock" });

        // Cek Double Request
        const [activeLoans] = await db.promise().query(
            "SELECT * FROM loans WHERE user_id = ? AND book_id = ? AND status IN ('borrowed', 'pending')", 
            [userId, bookId]
        );
        if (activeLoans.length > 0) return res.status(400).json({ message: "You already have a request for this book" });

        // Kurangi Stok & Buat Loan Pending
        await db.promise().query("UPDATE books SET stock = stock - 1 WHERE id = ?", [bookId]);
        await LoanModel.createLoan(userId, bookId); 

        res.json({ message: "Request submitted! Waiting for admin approval." });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// 2. Return Book (Sama seperti sebelumnya)
exports.returnBook = async (req, res) => {
    try {
        const { loanId, bookId } = req.body;
        if (!bookId) return res.status(400).json({ message: "Book ID is missing" });

        await LoanModel.returnLoan(loanId);
        await db.promise().query("UPDATE books SET stock = stock + 1 WHERE id = ?", [bookId]);

        res.json({ message: "Book returned successfully!" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// 3. Get My Loans (Sama seperti sebelumnya)
exports.getMyLoans = async (req, res) => {
    try {
        const userId = req.user.id;
        const [loans] = await LoanModel.getUserLoans(userId);
        res.json(loans);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// --- FITUR BARU ADMIN (UC-10) ---

// 4. Admin Lihat Request
exports.getAllLoans = async (req, res) => {
    try {
        const status = req.query.status;
        let query = `SELECT l.id, l.status, l.borrow_date, u.name as user_name, b.title as book_title 
                     FROM loans l
                     JOIN users u ON l.user_id = u.id
                     JOIN books b ON l.book_id = b.id`;
        
        if (status) query += ` WHERE l.status = '${status}'`;
        query += ` ORDER BY l.borrow_date DESC`;

        const [loans] = await db.promise().query(query);
        res.json(loans);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// 5. Admin Verifikasi (Approve/Reject)
exports.verifyLoan = async (req, res) => {
    try {
        const { loanId, action } = req.body; 

        if (action === 'approve') {
            await db.promise().query("UPDATE loans SET status = 'borrowed' WHERE id = ?", [loanId]);
            res.json({ message: "Loan approved successfully" });

        } else if (action === 'reject') {
            const [loanData] = await db.promise().query("SELECT book_id FROM loans WHERE id = ?", [loanId]);
            if (loanData.length > 0) {
                const bookId = loanData[0].book_id;
                await db.promise().query("UPDATE loans SET status = 'rejected' WHERE id = ?", [loanId]);
                await db.promise().query("UPDATE books SET stock = stock + 1 WHERE id = ?", [bookId]);
            }
            res.json({ message: "Loan rejected and stock returned" });
        } else {
            res.status(400).json({ message: "Invalid action" });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};