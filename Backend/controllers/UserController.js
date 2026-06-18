const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const UserModel = require('../models/UserModel');

exports.register = async (req, res) => {
    try {
        const { name, email, password, role } = req.body;

        // Input validation
        if (!name || !email || !password) {
            return res.status(400).json({ error: "Name, email, and password are required" });
        }

        if (password.length < 6) {
            return res.status(400).json({ error: "Password must be at least 6 characters long" });
        }

        // Email format validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({ error: "Invalid email format" });
        }

        // Check if user already exists
        const [existingUsers] = await UserModel.findByEmail(email);
        if (existingUsers.length > 0) {
            return res.status(400).json({ error: "User with this email already exists" });
        }

        // Validasi role, default ke 'Anggota' jika tidak disediakan
        const userRole = role && ['Admin', 'Anggota'].includes(role) ? role : 'Anggota';

        const hashedPassword = await bcrypt.hash(password, 10);

        await UserModel.createUser({ name, email, password: hashedPassword, role: userRole });

        res.json({ message: "User registered successfully!", role: userRole });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        const [users] = await UserModel.findByEmail(email);

        if (users.length === 0) {
            return res.status(400).json({ message: "User not found" });
        }

        const user = users[0];

        const validPassword = await bcrypt.compare(password, user.password);

        if (!validPassword) {
            return res.status(400).json({ message: "Invalid password" });
        }

        const token = jwt.sign({ 
            id: user.id, 
            email: user.email, 
            role: user.role 
        }, process.env.JWT_SECRET || "secretkey", {
            expiresIn: "1d"
        });

        res.json({ 
            message: "Login success", 
            token,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getProfile = async (req, res) => {
    try {
        const userId = req.user.id;
        const [users] = await UserModel.findById(userId);

        if (users.length === 0) {
            return res.status(404).json({ message: "User not found" });
        }

        const user = users[0];
        delete user.password; // Jangan kirim password ke client

        res.json({ user });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};



