const mysql = require('mysql2');
require('dotenv').config();

console.log("Database configuration:");
console.log("- Host:", process.env.DB_HOST);
console.log("- User:", process.env.DB_USER);
console.log("- Database:", process.env.DB_DATABASE);
console.log("- Port:", process.env.DB_PORT);

const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    port: process.env.DB_PORT
});

db.connect((err) => {
    if(err) {
        console.error("Failed to connect database:", err);
        console.error("Error code:", err.code);
        console.error("Error message:", err.message);
        return;
    }
    console.log("Success connect to database!");
});

module.exports = db;