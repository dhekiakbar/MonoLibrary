const db = require('./db');

db.ping((err) => {
    if (err) {
        console.error("Database connection failed");
        console.error(err);
        db.end();
        process.exit(1);
    }

    console.log("Database connection successful");
    db.end();
    process.exit(0);
});
