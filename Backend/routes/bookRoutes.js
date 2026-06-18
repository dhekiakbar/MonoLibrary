const express = require('express');
const router = express.Router();
const BookController = require('../controllers/BookController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');

// Route untuk mendapatkan semua buku - bisa diakses oleh semua user yang terautentikasi
router.get('/', authMiddleware, BookController.getBooks);

// Route untuk mendapatkan buku berdasarkan ID - bisa diakses oleh semua user yang terautentikasi
router.get('/:id', authMiddleware, BookController.getBookById);

// Route untuk create, update, dan delete - hanya bisa diakses oleh Admin
router.post('/', authMiddleware, roleMiddleware(['Admin']), BookController.createBook);
router.put('/:id', authMiddleware, roleMiddleware(['Admin']), BookController.updateBook);
router.delete('/:id', authMiddleware, roleMiddleware(['Admin']), BookController.deleteBook);

module.exports = router;



