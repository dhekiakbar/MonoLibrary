-- ====================================================
-- MONOLIBRARY DATABASE INITIALIZATION & SEEDING
-- ====================================================
-- File: init_database.sql
-- Tanggal: 2025-12-05
-- Deskripsi: Setup lengkap database dengan seeding data
-- ====================================================

-- Hapus database jika sudah ada (hati-hati di production!)
DROP DATABASE IF EXISTS monolibrary;

-- Buat database baru
CREATE DATABASE monolibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Gunakan database
USE monolibrary;

-- ====================================================
-- TABEL: users
-- ====================================================
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('Admin', 'Anggota') DEFAULT 'Anggota' NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================
-- TABEL: books
-- ====================================================
CREATE TABLE books (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  year INT NOT NULL,
  description TEXT,
  isbn VARCHAR(20),
  publisher VARCHAR(255),
  category VARCHAR(100),
  stock INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_title (title),
  INDEX idx_author (author),
  INDEX idx_category (category),
  INDEX idx_year (year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================
-- SEEDING DATA: Users
-- ====================================================
-- Password untuk semua user: password123
-- CATATAN: Hash ini adalah contoh. Setelah aplikasi jalan, 
--          register user baru akan otomatis meng-hash password dengan benar.
-- Hash bcrypt untuk 'password123': $2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi

INSERT INTO users (name, email, password, role) VALUES
('Administrator', 'admin@monolibrary.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin'),
('Super Admin', 'superadmin@monolibrary.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin'),
('John Doe', 'john@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota'),
('Jane Smith', 'jane@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota'),
('Alice Johnson', 'alice@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota'),
('Bob Williams', 'bob@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota');

-- ====================================================
-- SEEDING DATA: Books
-- ====================================================
INSERT INTO books (title, author, year, description, isbn, publisher, category, stock) VALUES
-- Fiksi & Sastra
('To Kill a Mockingbird', 'Harper Lee', 1960, 'Novel klasik tentang rasisme dan ketidakadilan di Amerika Selatan. Diceritakan melalui mata Scout Finch yang masih kecil.', '978-0-06-112008-4', 'J.B. Lippincott & Co.', 'Fiksi', 5),
('1984', 'George Orwell', 1949, 'Novel distopia tentang rezim totaliter yang mengontrol setiap aspek kehidupan masyarakat.', '978-0-452-28423-4', 'Secker & Warburg', 'Fiksi', 3),
('Pride and Prejudice', 'Jane Austen', 1813, 'Kisah romantis tentang Elizabeth Bennet dan Mr. Darcy di Inggris abad ke-19.', '978-0-14-143951-8', 'T. Egerton', 'Romance', 4),
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Potret kehidupan mewah dan tragedi di era Jazz Amerika.', '978-0-7432-7356-5', 'Charles Scribner\'s Sons', 'Fiksi', 6),
('Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling', 1997, 'Petualangan magis Harry Potter di Sekolah Sihir Hogwarts.', '978-0-7475-3269-9', 'Bloomsbury', 'Fantasy', 8),

-- Non-Fiksi & Pengembangan Diri
('Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 2011, 'Sejarah umat manusia dari evolusi hingga revolusi kognitif, pertanian, dan sains.', '978-0-06-231609-7', 'Harvill Secker', 'Sejarah', 4),
('Atomic Habits', 'James Clear', 2018, 'Panduan praktis membangun kebiasaan baik dan menghilangkan kebiasaan buruk.', '978-0-7352-1129-2', 'Avery', 'Self-Help', 7),
('Thinking, Fast and Slow', 'Daniel Kahneman', 2011, 'Eksplorasi tentang dua sistem berpikir manusia dan bias kognitif.', '978-0-374-27563-1', 'Farrar, Straus and Giroux', 'Psikologi', 3),
('The Lean Startup', 'Eric Ries', 2011, 'Metodologi untuk membangun startup yang sukses dengan validasi cepat.', '978-0-307-88789-4', 'Crown Business', 'Bisnis', 5),
('Educated', 'Tara Westover', 2018, 'Memoir inspiratif tentang kekuatan pendidikan mengubah hidup.', '978-0-399-59050-4', 'Random House', 'Biografi', 4),

-- Teknologi & Programming
('Clean Code', 'Robert C. Martin', 2008, 'Panduan praktis menulis kode yang bersih, mudah dipahami, dan maintainable.', '978-0-13-235088-4', 'Prentice Hall', 'Programming', 6),
('The Pragmatic Programmer', 'Andrew Hunt, David Thomas', 1999, 'Tips dan teknik praktis menjadi programmer profesional yang lebih baik.', '978-0-13-595705-9', 'Addison-Wesley', 'Programming', 4),
('Design Patterns', 'Gang of Four', 1994, 'Referensi klasik tentang design patterns dalam software engineering.', '978-0-201-63361-0', 'Addison-Wesley', 'Programming', 3),
('You Don\'t Know JS', 'Kyle Simpson', 2014, 'Panduan mendalam tentang JavaScript dan konsep-konsep fundamental.', '978-1-491-90419-7', 'O\'Reilly Media', 'Programming', 5),
('Introduction to Algorithms', 'Thomas H. Cormen', 2009, 'Textbook komprehensif tentang algoritma dan struktur data.', '978-0-262-03384-8', 'MIT Press', 'Computer Science', 2),

-- Fiksi Ilmiah & Fantasy
('The Hobbit', 'J.R.R. Tolkien', 1937, 'Petualangan Bilbo Baggins di Middle-earth mencari harta karun naga.', '978-0-547-92822-7', 'Allen & Unwin', 'Fantasy', 5),
('Dune', 'Frank Herbert', 1965, 'Epik fiksi ilmiah tentang politik, agama, dan ekologi di planet Arrakis.', '978-0-441-17271-9', 'Chilton Books', 'Sci-Fi', 4),
('The Lord of the Rings', 'J.R.R. Tolkien', 1954, 'Trilogi epik tentang perjalanan menghancurkan One Ring.', '978-0-544-00341-5', 'Allen & Unwin', 'Fantasy', 6),
('Neuromancer', 'William Gibson', 1984, 'Novel cyberpunk yang mendefinisikan genre tentang hacker dan cyberspace.', '978-0-441-56956-6', 'Ace Books', 'Sci-Fi', 3),
('The Hunger Games', 'Suzanne Collins', 2008, 'Distopia tentang turnamen brutal di mana remaja bertarung hingga mati.', '978-0-439-02348-1', 'Scholastic Press', 'Dystopian', 7),

-- Indonesia & Lokal
('Laskar Pelangi', 'Andrea Hirata', 2005, 'Kisah inspiratif anak-anak Belitung yang berjuang untuk pendidikan.', '978-979-24-1999-8', 'Bentang Pustaka', 'Fiksi Indonesia', 8),
('Bumi Manusia', 'Pramoedya Ananta Toer', 1980, 'Novel sejarah tentang kehidupan di Indonesia masa kolonial Belanda.', '978-979-461-228-4', 'Hasta Mitra', 'Fiksi Indonesia', 5),
('Sang Pemimpi', 'Andrea Hirata', 2006, 'Kelanjutan Laskar Pelangi tentang mimpi dan perjuangan di Paris.', '978-979-24-2454-1', 'Bentang Pustaka', 'Fiksi Indonesia', 6),
('Perahu Kertas', 'Dee Lestari', 2009, 'Kisah romansa modern tentang dua jiwa yang saling mencari.', '978-979-24-2961-4', 'Bentang Pustaka', 'Romance Indonesia', 7),
('Negeri 5 Menara', 'Ahmad Fuadi', 2009, 'Inspirasi dari pesantren tentang persahabatan dan meraih mimpi.', '978-602-8496-06-7', 'Gramedia Pustaka Utama', 'Fiksi Indonesia', 6);

-- ====================================================
-- VERIFIKASI DATA
-- ====================================================
SELECT '========================================' AS '';
SELECT 'DATABASE INITIALIZATION COMPLETED!' AS 'STATUS';
SELECT '========================================' AS '';

SELECT 'Total Users:' AS 'Info', COUNT(*) AS 'Count' FROM users;
SELECT 'Total Books:' AS 'Info', COUNT(*) AS 'Count' FROM books;

SELECT '========================================' AS '';
SELECT 'USERS BY ROLE:' AS '';
SELECT role, COUNT(*) as total FROM users GROUP BY role;

SELECT '========================================' AS '';
SELECT 'BOOKS BY CATEGORY:' AS '';
SELECT category, COUNT(*) as total FROM books GROUP BY category ORDER BY total DESC;

SELECT '========================================' AS '';
SELECT 'DEFAULT LOGIN CREDENTIALS:' AS '';
SELECT '----------------------------------------' AS '';
SELECT 'Admin Account:' AS 'Type', 'admin@monolibrary.com' AS 'Email', 'password123' AS 'Password';
SELECT 'Member Account:' AS 'Type', 'john@example.com' AS 'Email', 'password123' AS 'Password';
SELECT '----------------------------------------' AS '';
SELECT 'NOTE: Password harus di-hash dengan bcrypt di aplikasi!' AS 'IMPORTANT';
SELECT '========================================' AS '';
