const db = require('../config/db');

const UserModel = {
    findByEmail: (email) => {
        return db.promise().query("SELECT * FROM users WHERE email = ?", [email]);
    },

    findById: (id) => {
        return db.promise().query("SELECT * FROM users WHERE id = ?", [id]);
    },

    createUser: (data) => {
        return db.promise().query("INSERT INTO users SET ?", data);
    },

    updateUser: (data, id) => {
        return db.promise().query("UPDATE users SET ? WHERE id = ?", [data, id]);
    }
};

exports.getUserByEmail = (email) => {
    return db.promise().query("SELECT * FROM users WHERE email = ?", [email]);
}

module.exports = UserModel;



