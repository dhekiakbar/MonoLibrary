const db = require('../config/db');

const UserModel = {
    // 1. Cari user berdasarkan email (Aman dari error syntax)
    findByEmail: (email) => {
        return db.promise().query("SELECT * FROM users WHERE email = ?", [email]);
    },

    // 2. Buat user baru
    createUser: (name, email, password) => {
        // Role default selalu 'Anggota' saat register
        return db.promise().query(
            "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'Anggota')",
            [name, email, password]
        );
    }
};

module.exports = UserModel;