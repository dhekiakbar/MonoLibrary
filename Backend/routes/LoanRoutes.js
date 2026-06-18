const express = require('express');
const router = express.Router();
const LoanController = require('../controllers/LoanController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware'); // Pastikan import ini!

// Member Routes
router.post('/borrow', authMiddleware, LoanController.borrowBook);
router.post('/return', authMiddleware, LoanController.returnBook);
router.get('/my-loans', authMiddleware, LoanController.getMyLoans);

// Admin Routes (UC-10) - INI YANG KEMARIN HILANG
router.get('/all', authMiddleware, roleMiddleware(['Admin']), LoanController.getAllLoans);
router.post('/verify', authMiddleware, roleMiddleware(['Admin']), LoanController.verifyLoan);

module.exports = router;