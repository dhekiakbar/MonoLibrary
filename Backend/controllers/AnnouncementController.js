const AnnouncementModel = require('../models/AnnouncementModel');

exports.getAll = async (req, res) => {
    try {
        const [data] = await AnnouncementModel.getAll();
        res.json(data);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.create = async (req, res) => {
    try {
        const { title, content } = req.body;
        if (!title || !content) return res.status(400).json({ message: "Title and content required" });
        
        await AnnouncementModel.create(title, content);
        res.status(201).json({ message: "Announcement created" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await AnnouncementModel.delete(req.params.id);
        res.json({ message: "Announcement deleted" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};