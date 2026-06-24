DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO categories (id, name) VALUES 
(1, 'Fiksi'),
(2, 'Sains'),
(3, 'Sejarah'),
(4, 'Teknologi'),
(5, 'Fiksi Indonesia'),
(6, 'Romance Indonesia'),
(7, 'Dystopian'),
(8, 'Sci-Fi'),
(9, 'Fantasy'),
(10, 'Computer Science'),
(11, 'Programming'),
(12, 'Biografi'),
(13, 'Bisnis'),
(14, 'Psikologi');