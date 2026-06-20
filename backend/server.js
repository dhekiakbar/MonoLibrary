const express = require('express');
const cors = require('cors');
const db = require('./config/db');
require('dotenv').config();
const path = require('path');

const bookRoutes = require('./routes/bookRoutes');
const userRoutes = require('./routes/userRoutes');
const LoanRoutes = require('./routes/LoanRoutes');

const announcementRoutes = require('./routes/announcementRoutes');

const app = express();

// Configure CORS properly
const corsOptions = {
    origin: [
        'http://10.10.10.144',
        'http://10.10.10.144:80',
        'http://10.10.10.144:8080',
        'http://localhost',
        'http://localhost:3000',
        'http://localhost:8080',
        'http://127.0.0.1',
        'null'
    ],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};

app.use(cors(corsOptions));
app.use(express.json());

// STATIC FOLDER
app.use(express.static(path.join(__dirname, 'public')));


// API ROUTES
app.use('/api/books', bookRoutes);
app.use('/api/users', userRoutes);
app.use('/api/loans', LoanRoutes);
app.use('/api/announcements', announcementRoutes);

// Test routes
app.get('/api/healthcheck', (req, res) => {
    res.json({ message: "Server its Work!" });
});

app.get('/api/dbtest', (req, res) => {
    db.query('SELECT 1 + 1 AS result', (err, results) => {
        if (err) {
            console.error('Database connection error:', err);
            return res.status(500).json({ error: 'Database connection failed', details: err.message });
        }
        res.json({ 
            message: 'Database connection successful', 
            result: results[0].result,
            timestamp: new Date().toISOString()
        });
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server work on PORT ${PORT}`);
});



