-- ====================================================
-- SEEDING DATA ONLY (Tanpa Drop Database)
-- ====================================================
-- File: seed_data.sql
-- Gunakan ini jika database dan tabel sudah ada
-- ====================================================

USE monolibrary;

-- ====================================================
-- Hapus data lama (opsional)
-- ====================================================
-- TRUNCATE TABLE users;
-- TRUNCATE TABLE books;

-- ====================================================
-- SEED: Users
-- ====================================================
-- Password: password123
INSERT INTO users (name, email, password, role) VALUES
('Administrator', 'admin@monolibrary.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin'),
('Super Admin', 'superadmin@monolibrary.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin'),
('John Doe', 'john@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota'),
('Jane Smith', 'jane@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota'),
('Alice Johnson', 'alice@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota'),
('Bob Williams', 'bob@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anggota')
ON DUPLICATE KEY UPDATE name=name;

-- ====================================================
-- SEED: Books
-- ====================================================
INSERT INTO books (title, author, year, description, isbn, publisher, category, stock) VALUES
-- Fiksi & Sastra
('To Kill a Mockingbird', 'Harper Lee', 1960, 'Novel klasik tentang rasisme dan ketidakadilan di Amerika Selatan.', '978-0-06-112008-4', 'J.B. Lippincott & Co.', 'Fiksi', 5),
('1984', 'George Orwell', 1949, 'Novel distopia tentang rezim totaliter yang mengontrol setiap aspek kehidupan.', '978-0-452-28423-4', 'Secker & Warburg', 'Fiksi', 3),
('Pride and Prejudice', 'Jane Austen', 1813, 'Kisah romantis tentang Elizabeth Bennet dan Mr. Darcy di Inggris abad ke-19.', '978-0-14-143951-8', 'T. Egerton', 'Romance', 4),
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Potret kehidupan mewah dan tragedi di era Jazz Amerika.', '978-0-7432-7356-5', 'Charles Scribner\'s Sons', 'Fiksi', 6),
('Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling', 1997, 'Petualangan magis Harry Potter di Sekolah Sihir Hogwarts.', '978-0-7475-3269-9', 'Bloomsbury', 'Fantasy', 8),

-- Non-Fiksi
('Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 2011, 'Sejarah umat manusia dari evolusi hingga revolusi kognitif.', '978-0-06-231609-7', 'Harvill Secker', 'Sejarah', 4),
('Atomic Habits', 'James Clear', 2018, 'Panduan praktis membangun kebiasaan baik dan menghilangkan kebiasaan buruk.', '978-0-7352-1129-2', 'Avery', 'Self-Help', 7),
('Thinking, Fast and Slow', 'Daniel Kahneman', 2011, 'Eksplorasi tentang dua sistem berpikir manusia dan bias kognitif.', '978-0-374-27563-1', 'Farrar, Straus and Giroux', 'Psikologi', 3),
('The Lean Startup', 'Eric Ries', 2011, 'Metodologi untuk membangun startup yang sukses dengan validasi cepat.', '978-0-307-88789-4', 'Crown Business', 'Bisnis', 5),
('Educated', 'Tara Westover', 2018, 'Memoir inspiratif tentang kekuatan pendidikan mengubah hidup.', '978-0-399-59050-4', 'Random House', 'Biografi', 4),

-- Programming
('Clean Code', 'Robert C. Martin', 2008, 'Panduan praktis menulis kode yang bersih dan maintainable.', '978-0-13-235088-4', 'Prentice Hall', 'Programming', 6),
('The Pragmatic Programmer', 'Andrew Hunt, David Thomas', 1999, 'Tips dan teknik praktis menjadi programmer profesional.', '978-0-13-595705-9', 'Addison-Wesley', 'Programming', 4),
('Design Patterns', 'Gang of Four', 1994, 'Referensi klasik tentang design patterns dalam software engineering.', '978-0-201-63361-0', 'Addison-Wesley', 'Programming', 3),
('You Don\'t Know JS', 'Kyle Simpson', 2014, 'Panduan mendalam tentang JavaScript dan konsep-konsep fundamental.', '978-1-491-90419-7', 'O\'Reilly Media', 'Programming', 5),
('Introduction to Algorithms', 'Thomas H. Cormen', 2009, 'Textbook komprehensif tentang algoritma dan struktur data.', '978-0-262-03384-8', 'MIT Press', 'Computer Science', 2),

-- Fantasy & Sci-Fi
('The Hobbit', 'J.R.R. Tolkien', 1937, 'Petualangan Bilbo Baggins di Middle-earth mencari harta karun naga.', '978-0-547-92822-7', 'Allen & Unwin', 'Fantasy', 5),
('Dune', 'Frank Herbert', 1965, 'Epik fiksi ilmiah tentang politik, agama, dan ekologi di planet Arrakis.', '978-0-441-17271-9', 'Chilton Books', 'Sci-Fi', 4),
('The Lord of the Rings', 'J.R.R. Tolkien', 1954, 'Trilogi epik tentang perjalanan menghancurkan One Ring.', '978-0-544-00341-5', 'Allen & Unwin', 'Fantasy', 6),
('Neuromancer', 'William Gibson', 1984, 'Novel cyberpunk yang mendefinisikan genre tentang hacker dan cyberspace.', '978-0-441-56956-6', 'Ace Books', 'Sci-Fi', 3),
('The Hunger Games', 'Suzanne Collins', 2008, 'Distopia tentang turnamen brutal di mana remaja bertarung hingga mati.', '978-0-439-02348-1', 'Scholastic Press', 'Dystopian', 7),

-- Indonesia
('Laskar Pelangi', 'Andrea Hirata', 2005, 'Kisah inspiratif anak-anak Belitung yang berjuang untuk pendidikan.', '978-979-24-1999-8', 'Bentang Pustaka', 'Fiksi Indonesia', 8),
('Bumi Manusia', 'Pramoedya Ananta Toer', 1980, 'Novel sejarah tentang kehidupan di Indonesia masa kolonial Belanda.', '978-979-461-228-4', 'Hasta Mitra', 'Fiksi Indonesia', 5),
('Sang Pemimpi', 'Andrea Hirata', 2006, 'Kelanjutan Laskar Pelangi tentang mimpi dan perjuangan di Paris.', '978-979-24-2454-1', 'Bentang Pustaka', 'Fiksi Indonesia', 6),
('Perahu Kertas', 'Dee Lestari', 2009, 'Kisah romansa modern tentang dua jiwa yang saling mencari.', '978-979-24-2961-4', 'Bentang Pustaka', 'Romance Indonesia', 7),
('Negeri 5 Menara', 'Ahmad Fuadi', 2009, 'Inspirasi dari pesantren tentang persahabatan dan meraih mimpi.', '978-602-8496-06-7', 'Gramedia Pustaka Utama', 'Fiksi Indonesia', 6)
ON DUPLICATE KEY UPDATE title=title;

-- ====================================================
-- Verification
-- ====================================================
SELECT 'Seeding completed!' AS Status;
SELECT COUNT(*) AS 'Total Users' FROM users;
SELECT COUNT(*) AS 'Total Books' FROM books;
