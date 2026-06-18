// ====================================================
// HASH PASSWORD GENERATOR FOR SEEDING
// ====================================================
// File: generate_password_hash.js
// Deskripsi: Generate bcrypt hash untuk password seeding
// ====================================================

const bcrypt = require('bcrypt');

const passwords = [
  { label: 'Admin Password', password: 'admin123' },
  { label: 'Member Password', password: 'password123' }
];

async function generateHashes() {
  console.log('====================================================');
  console.log('GENERATING PASSWORD HASHES FOR SEEDING');
  console.log('====================================================\n');

  for (const item of passwords) {
    const hash = await bcrypt.hash(item.password, 10);
    console.log(`${item.label}:`);
    console.log(`  Plain Text: ${item.password}`);
    console.log(`  Hash: ${hash}`);
    console.log('');
  }

  console.log('====================================================');
  console.log('Copy hash di atas ke file init_database.sql');
  console.log('====================================================');
}

generateHashes().catch(console.error);
