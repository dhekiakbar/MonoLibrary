const express = require('express');
const cors = require('cors');
const db = require('./config/db');
require('dotenv').config();
const bookRoutes = require('./routes/bookRoutes');
const userRoutes = require('./routes/userRoutes');

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
        'null' // for file:// protocol
    ],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};

app.use(cors(corsOptions));
app.use(express.json());
app.use('/api/books', bookRoutes);
app.use('/api/users', userRoutes);

//route test
app.get('/api/healthcheck', (req, res) => {
    res.json({ message: "Server its Work!"});
} );

//database test route
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

