-- Migration: Tambah kolom role ke tabel users
-- Tanggal: 2025-12-05
-- Deskripsi: Menambahkan sistem role (Admin dan Anggota) untuk kontrol akses

-- Tambah kolom role jika belum ada
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS role ENUM('Admin', 'Anggota') DEFAULT 'Anggota' NOT NULL;

-- Update user yang sudah ada (opsional - sesuaikan dengan kebutuhan)
-- UPDATE users SET role = 'Admin' WHERE email = 'admin@example.com';

-- Contoh: Buat admin default jika belum ada
INSERT INTO users (name, email, password, role) 
VALUES (
    'Administrator', 
    'admin@monolibrary.com', 
    -- Password: admin123 (harus di-hash dengan bcrypt di aplikasi)
    '$2b$10$XQKyK.N5xZqT5vH9Y7YVIeVxKyK.N5xZqT5vH9Y7YVIeVxKyK.N5x', 
    'Admin'
)
ON DUPLICATE KEY UPDATE role = 'Admin';

-- Verifikasi perubahan
SELECT * FROM users;
