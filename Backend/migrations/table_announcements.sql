--Tambahkan migrasi untuk tabel announcements--
--Buat tabel announcements untuk menyimpan pengumuman di database--
-- Tabel Announcements (Pengumuman)
CREATE TABLE announcements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);