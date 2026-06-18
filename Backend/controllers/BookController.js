const BookModel = require('../models/BookModel');

exports.getBooks = async (req, res) => {
  try {
    const [result] = await BookModel.getAllBooks();
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getBookById = async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await BookModel.getBookById(id);
    
    if (result.length === 0) {
      return res.status(404).json({ message: "Book not found" });
    }
    
    res.json(result[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createBook = async (req, res) => {
  try {
    const { title, author, year, description } = req.body;
    await BookModel.createBook({ title, author, year, description });
    res.json({ message: "Book added successfully!" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateBook = async (req, res) => {
  try {
    const { title, author, year, description } = req.body;
    const { id } = req.params;
    await BookModel.updateBook({ title, author, year, description }, id);
    res.json({ message: "Book updated successfully!" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteBook = async (req, res) => {
  try {
    const { id } = req.params;
    await BookModel.deleteBook(id);
    res.json({ message: "Book deleted successfully!" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};



