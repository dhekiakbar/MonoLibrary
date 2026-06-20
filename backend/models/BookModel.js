const db = require('../config/db');

exports.getAllBooks = (keyword) => {
  if (keyword) {
    const search = `%${keyword}%`; 
    return db.promise().query(
      "SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR category LIKE ?", 
      [search, search, search]
    );
  }
  return db.promise().query("SELECT * FROM books");
};

exports.getBookById = (id) => {
  return db.promise().query("SELECT * FROM books WHERE id = ?", [id]);
};

exports.createBook = (data) => {
  return db.promise().query("INSERT INTO books SET ?", data);
};

exports.updateBook = (id, bookData) => {
    const { title, author, year, description, category, stock } = bookData;
    return db.promise().query(
        "UPDATE books SET title = ?, author = ?, year = ?, description = ?, category = ?, stock = ? WHERE id = ?",
        [title, author, year, description, category, stock, id]
    );
}; 

exports.deleteBook = (id) => {
  return db.promise().query("DELETE FROM books WHERE id = ?", [id]);
};