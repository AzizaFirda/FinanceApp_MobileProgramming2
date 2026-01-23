# 📋 Step-by-Step Setup Guide untuk Supabase Database

## Overview
Panduan lengkap setup Supabase database untuk Money Manager app dengan screenshots dan penjelasan detail.

---

## Prerequisites

✅ Akun Supabase (sudah ada: https://supabase.com)
✅ Project Money Manager sudah dibuat
✅ URL: `https://omnftoowpnvmtbzfrcig.supabase.co`
✅ Anon Key: `sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq`

---

## FASE 1: Setup Database Tables

### Langkah 1.1: Buka Supabase Console
1. Buka browser → https://supabase.com/dashboard
2. Login dengan email Anda
3. Pilih project **"money_manager"**

### Langkah 1.2: Akses SQL Editor
1. Di sidebar kiri, cari **SQL Editor**
2. Klik **SQL Editor**
3. Klik tombol **+ New query** (warna biru)

### Langkah 1.3: Copy SQL Script
1. Buka file: `SUPABASE_DATABASE_SETUP.md` (di project root)
2. Copy SEMUA kode SQL dari section **"SQL Script - Complete Database Setup"**
   - Mulai dari: `-- =====================================================`
   - Sampai akhir script

### Langkah 1.4: Paste & Execute
1. Di SQL Editor, cursor di text area
2. Paste kode SQL yang sudah di-copy
3. Klik tombol **Run** (warna biru, kanan bawah)
4. Tunggu sampai ada notifikasi ✅ **Success**
   - Jika ada error, cek kembali kode SQL

### Langkah 1.5: Verifikasi Tables Terbuat
1. Sidebar kiri → **Database** → **Tables**
2. Harus ada 5 tables:
   - ✅ `users`
   - ✅ `accounts`
   - ✅ `categories`
   - ✅ `transactions`
   - ✅ `budgets`

---

## FASE 2: Setup Storage Bucket untuk Foto

### Langkah 2.1: Buka Storage
1. Sidebar kiri → **Storage**
2. Klik tab **Buckets**

### Langkah 2.2: Buat Bucket Baru
1. Klik tombol **+ New bucket** (warna biru)
2. Dialog akan muncul dengan form:
   - **Bucket name:** `profiles` (huruf kecil, no space)
   - **Public bucket:** ✅ Centang (agar bisa diakses public)
3. Klik **Create bucket**

### Langkah 2.3: Verifikasi Bucket Terbuat
1. Harus ada bucket bernama `profiles` di daftar
2. Kolom "Type" harus: **Public**

---

## FASE 3: Setup Authentication

### Langkah 3.1: Cek Auth Configuration
1. Sidebar kiri → **Authentication**
2. Klik tab **Providers**
3. Email harus sudah enabled (default dari Supabase)

### Langkah 3.2: Setup Email Settings (Optional, tapi recommended)
1. Sidebar kiri → **Authentication**
2. Klik tab **Email Templates**
3. Customize email templates untuk:
   - ✉️ Sign-up confirmation
   - 🔑 Password reset
   - ⚠️ Change email verification

### Langkah 3.3: Setup Redirect URLs
1. Sidebar kiri → **Authentication**
2. Klik tab **URL Configuration**
3. Scroll ke **Redirect URLs**
4. Tambahkan URL untuk testing (optional):
   - `http://localhost:5000`
   - `http://localhost:3000`
   - Untuk production: URL aplikasi Flutter web Anda

---

## FASE 4: Setup RLS (Row Level Security) Policies

### Langkah 4.1: Verify RLS Status
1. Sidebar kiri → **Database** → **Tables**
2. Klik table **users**
3. Scroll ke section **RLS Policies**
4. Harus ada policies:
   - Users can view own profile
   - Users can update own profile
   - Users can insert own profile

### Langkah 4.2: Check All Tables
Repeat langkah 4.1 untuk tables:
- ✅ `accounts` (4 policies)
- ✅ `categories` (4 policies)
- ✅ `transactions` (4 policies)
- ✅ `budgets` (4 policies)

**Catatan:** Jika ada policy yang missing, run SQL script lagi, fokus di section "CREATE RLS POLICIES"

---

## FASE 5: Verifikasi Setup dengan Testing

### Langkah 5.1: Test User Registration
1. Sidebar kiri → **Authentication** → **Users**
2. Klik tombol **+ Add user** (untuk testing)
3. Isi:
   - Email: `test@example.com`
   - Password: `Test@12345` (minimal 6 karakter)
4. Klik **Create user**
5. User akan muncul di daftar

### Langkah 5.2: Test Database Access
1. Sidebar kiri → **SQL Editor**
2. Buat query baru:

```sql
-- Get current user ID
SELECT auth.uid() as current_user_id;

-- Get user profile
SELECT * FROM public.users WHERE id = auth.uid();

-- Get accounts for current user
SELECT * FROM public.accounts WHERE user_id = auth.uid();
```

3. Klik **Run**
4. Harus tidak ada error dan muncul hasil data

### Langkah 5.3: Test Photo Upload
1. Sidebar kiri → **Storage** → **profiles** bucket
2. Klik **Upload file**
3. Pilih foto dari komputer
4. Tunggu upload selesai
5. Klik file yang diupload
6. Copy **Public URL** (gunakan di app later)

---

## FASE 6: Setup Firewall Rules (Optional - Enterprise Only)

Untuk production, setup API key restrictions:

1. Sidebar kiri → **Project Settings** → **API**
2. Scroll ke **API Keys**
3. Ada 2 keys:
   - **anon key** (public) - untuk client app
   - **service_role key** (secret) - untuk server only

### PENTING: Jangan share service_role key!

---

## TESTING CHECKLIST

Setelah semua setup selesai, verify dengan checklist ini:

- [ ] 5 tables sudah dibuat
- [ ] `profiles` bucket exist dan berstatus Public
- [ ] RLS policies aktif untuk semua tables
- [ ] Test user bisa login
- [ ] Test query bisa akses data
- [ ] Foto bisa diupload ke storage

---

## API Endpoints yang Auto-Generated

Supabase otomatis generate REST API endpoints. Contoh:

```
GET https://omnftoowpnvmtbzfrcig.supabase.co/rest/v1/users
  ?select=*

GET https://omnftoowpnvmtbzfrcig.supabase.co/rest/v1/accounts
  ?user_id=eq.USER_ID
  &order=created_at.desc

POST https://omnftoowpnvmtbzfrcig.supabase.co/rest/v1/transactions
  (body: transaction data)
```

Lihat `SUPABASE_API_REFERENCE.md` untuk lengkap.

---

## Troubleshooting

### ❌ Error: "permission denied for schema public"
**Solusi:** Pastikan Anda logged in dengan akun yang own project

### ❌ Error: "relation does not exist"
**Solusi:** 
1. Run SQL script lagi
2. Pastikan no syntax error di SQL

### ❌ Error: "new row violates row-level security policy"
**Solusi:** Pastikan `user_id` di record sama dengan `auth.uid()`

### ❌ Foto upload error
**Solusi:**
1. Pastikan bucket `profiles` exist
2. Check bucket status: harus **Public**
3. Check bucket policies di Storage section

### ❌ Tidak bisa query data
**Solusi:**
1. Pastikan RLS policies sudah dibuat
2. Check yang query user ID sesuai dengan auth.uid()
3. Cek network tab di DevTools

---

## Next Steps untuk Flutter Integration

Setelah database setup selesai:

1. **Update Repositories** - Ubah query lokal jadi Supabase query
   - Lihat: `SUPABASE_API_REFERENCE.md`

2. **Update Models** - Ensure ada `toJson()` dan `fromJson()`

3. **Update Providers** - Setup call ke repository dengan Supabase

4. **Test Sync** - Test CRUD operations dari app

5. **Setup Offline** - Setup Hive untuk caching lokal

---

## Useful Links

- **Supabase Dashboard:** https://supabase.com/dashboard
- **Supabase Docs:** https://supabase.com/docs
- **SQL Editor Docs:** https://supabase.com/docs/guides/database/sql-editor
- **RLS Docs:** https://supabase.com/docs/guides/auth/row-level-security
- **Storage Docs:** https://supabase.com/docs/guides/storage

---

## Support

Jika ada issue:
1. Check **Project Logs** di Supabase Console
2. Check network requests di Flutter DevTools
3. Check SQL query di SQL Editor
4. Refer ke troubleshooting section

---

## ✅ Setup Complete!

Sekarang database siap untuk Money Manager app. Aplikasi bisa langsung:
- Login/Register dengan Supabase Auth ✅
- CRUD Accounts, Categories, Transactions, Budgets ✅
- Upload/Download foto profil ✅
- Real-time sync dengan database ✅

Selamat! 🎉

