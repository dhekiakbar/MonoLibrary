const express = require('express');
const router = express.Router();
const AnnouncementController = require('../controllers/AnnouncementController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');

// Public (Bisa dilihat siapa saja, termasuk di Home)
router.get('/', AnnouncementController.getAll);

// Admin Only (Buat dan Hapus)
router.post('/', authMiddleware, roleMiddleware(['Admin']), AnnouncementController.create);
router.delete('/:id', authMiddleware, roleMiddleware(['Admin']), AnnouncementController.delete);

module.exports = router;