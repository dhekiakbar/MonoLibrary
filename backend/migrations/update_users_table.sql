-- ========================================================
-- MIGRATION: Update Tabel Users
-- Deskripsi: Menambahkan kolom country_id dan birth_date 
--            dari fitur Create User Admin
-- ========================================================

ALTER TABLE users
ADD COLUMN country_id VARCHAR(10) NULL AFTER role,
ADD COLUMN birth_date DATE NULL AFTER country_id;