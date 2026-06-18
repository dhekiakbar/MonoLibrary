const db = require('../config/db');

exports.getAllBooks = () => {
  return db.promise().query("SELECT * FROM books");
};

exports.getBookById = (id) => {
  return db.promise().query("SELECT * FROM books WHERE id = ?", [id]);
};

exports.createBook = (data) => {
  return db.promise().query("INSERT INTO books SET ?", data);
};

exports.updateBook = (data, id) => {
  return db.promise().query("UPDATE books SET ? WHERE id = ?", [data, id]);
};

exports.deleteBook = (id) => {
  return db.promise().query("DELETE FROM books WHERE id = ?", [id]);
};



