const express = require('express');
const router = express.Router();
const UserController = require('../controllers/UserController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');

router.post('/register', UserController.register);
router.post('/login', UserController.login);
router.get('/profile', authMiddleware, UserController.getProfile);
router.get('/stats', authMiddleware, roleMiddleware(['Admin']), UserController.getDashboardStats);
router.get('/', authMiddleware, roleMiddleware(['Admin']), UserController.getAllUsers);
router.delete('/:id', authMiddleware, roleMiddleware(['Admin']), UserController.deleteUser);
router.put('/profile', authMiddleware, UserController.updateProfile);

module.exports = router;