const db = require('../config/db');

const AnnouncementModel = {
    getAll: () => {
        return db.promise().query("SELECT * FROM announcements ORDER BY created_at DESC");
    },
    create: (title, content) => {
        return db.promise().query("INSERT INTO announcements (title, content) VALUES (?, ?)", [title, content]);
    },
    delete: (id) => {
        return db.promise().query("DELETE FROM announcements WHERE id = ?", [id]);
    }
};

module.exports = AnnouncementModel;