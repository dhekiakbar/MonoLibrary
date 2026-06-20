const db = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const UserModel = require('../models/UserModel');

exports.register = async (req, res) => {
    try {
        const { name, email, password } = req.body;
        if (!name || !email || !password) return res.status(400).json({ message: "All fields are required" });

        const [existingUser] = await UserModel.findByEmail(email);
        if (existingUser.length > 0) return res.status(400).json({ message: "Email already exists" });

        const hashedPassword = await bcrypt.hash(password, 10);
        await UserModel.createUser(name, email, hashedPassword);
        res.status(201).json({ message: "User registered successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const [users] = await UserModel.findByEmail(email);
        if (users.length === 0) return res.status(404).json({ message: "User not found" });

        const user = users[0];
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

        const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1d' });
        
        res.json({
            message: "Login successful",
            token,
            user: { id: user.id, name: user.name, email: user.email, role: user.role }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getProfile = async (req, res) => {
    try {
        const [users] = await db.promise().query("SELECT id, name, email, role, created_at FROM users WHERE id = ?", [req.user.id]);
        if (users.length === 0) return res.status(404).json({ message: "User not found" });
        res.json({ user: users[0] });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// --- FITUR BARU UNTUK ADMIN (UC-09) ---

exports.getDashboardStats = async (req, res) => {
    try {
        const [users] = await db.promise().query("SELECT COUNT(*) as count FROM users");
        const [newUsers] = await db.promise().query("SELECT COUNT(*) as count FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
        // Hitung yang statusnya 'borrowed' (sedang dipinjam aktif)
        const [active] = await db.promise().query("SELECT COUNT(DISTINCT user_id) as count FROM loans WHERE status = 'borrowed'");

        res.json({
            totalUsers: users[0].count,
            newUsers: newUsers[0].count,
            activeReaders: active[0] ? active[0].count : 0
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getAllUsers = async (req, res) => {
    try {
        const [users] = await db.promise().query("SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC");
        res.json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        await db.promise().query("DELETE FROM users WHERE id = ?", [id]);
        res.json({ message: "User deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updateProfile = async (req, res) => {
    try {
        const userId = req.user.id;
        const { name, email } = req.body;
        await db.promise().query("UPDATE users SET name = ?, email = ? WHERE id = ?", [name, email, userId]);
        res.json({ message: "Profile updated successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};