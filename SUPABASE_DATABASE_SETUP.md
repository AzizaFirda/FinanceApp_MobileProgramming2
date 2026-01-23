# Supabase Database Setup for Money Manager App

## Overview
Panduan lengkap untuk setup database Supabase untuk aplikasi Money Manager Flutter dengan struktur yang sesuai dengan models aplikasi.

**Supabase URL:** `https://omnftoowpnvmtbzfrcig.supabase.co`
**Anon Key:** `sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq`

---

## Langkah-Langkah Setup

### 1. Login ke Supabase Console
Buka https://supabase.com/dashboard dan login dengan akun Anda

### 2. Pilih Project
Masuk ke project Money Manager yang sudah dibuat

### 3. Buka SQL Editor
Di sidebar kiri, pilih **SQL Editor** → **New Query**

### 4. Copy & Paste SQL Script
Copy semua SQL di bawah ini, paste ke SQL Editor, kemudian klik **Run**

---

## SQL Script - Complete Database Setup

```sql
-- =====================================================
-- 1. CREATE TABLES
-- =====================================================

-- 1.1 Users Table (Extended Profile from Auth)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY DEFAULT auth.uid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  photo_url TEXT,
  currency TEXT DEFAULT 'IDR',
  language TEXT DEFAULT 'id',
  date_format TEXT DEFAULT 'dd/MM/yyyy',
  theme_mode TEXT DEFAULT 'system',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 1.2 Accounts Table
CREATE TABLE IF NOT EXISTS public.accounts (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'cash' CHECK (type IN ('cash', 'bank', 'ewallet', 'liability')),
  icon TEXT NOT NULL,
  color INTEGER NOT NULL DEFAULT -1049552127,
  initial_balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
  current_balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 1.3 Categories Table
CREATE TABLE IF NOT EXISTS public.categories (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('expense', 'income')),
  icon TEXT NOT NULL,
  color INTEGER NOT NULL DEFAULT -1049552127,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 1.4 Transactions Table
CREATE TABLE IF NOT EXISTS public.transactions (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  account_id TEXT NOT NULL,
  category_id TEXT NOT NULL,
  to_account_id TEXT,
  amount DECIMAL(15, 2) NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
  note TEXT,
  date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 1.5 Budgets Table
CREATE TABLE IF NOT EXISTS public.budgets (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  category_id TEXT NOT NULL,
  amount DECIMAL(15, 2) NOT NULL,
  period TEXT NOT NULL DEFAULT 'monthly' CHECK (period IN ('weekly', 'monthly', 'yearly')),
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- 2. CREATE INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX idx_accounts_user_id ON public.accounts(user_id);
CREATE INDEX idx_accounts_is_active ON public.accounts(is_active);

CREATE INDEX idx_categories_user_id ON public.categories(user_id);
CREATE INDEX idx_categories_type ON public.categories(type);

CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_account_id ON public.transactions(account_id);
CREATE INDEX idx_transactions_category_id ON public.transactions(category_id);
CREATE INDEX idx_transactions_date ON public.transactions(date DESC);
CREATE INDEX idx_transactions_type ON public.transactions(type);

CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_budgets_category_id ON public.budgets(category_id);

-- =====================================================
-- 3. ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 4. CREATE RLS POLICIES
-- =====================================================

-- 4.1 Users Policies
CREATE POLICY "Users can view own profile"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- 4.2 Accounts Policies
CREATE POLICY "Users can view own accounts"
  ON public.accounts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own accounts"
  ON public.accounts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own accounts"
  ON public.accounts FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own accounts"
  ON public.accounts FOR DELETE
  USING (auth.uid() = user_id);

-- 4.3 Categories Policies
CREATE POLICY "Users can view own categories"
  ON public.categories FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own categories"
  ON public.categories FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own categories"
  ON public.categories FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own categories"
  ON public.categories FOR DELETE
  USING (auth.uid() = user_id);

-- 4.4 Transactions Policies
CREATE POLICY "Users can view own transactions"
  ON public.transactions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own transactions"
  ON public.transactions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own transactions"
  ON public.transactions FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own transactions"
  ON public.transactions FOR DELETE
  USING (auth.uid() = user_id);

-- 4.5 Budgets Policies
CREATE POLICY "Users can view own budgets"
  ON public.budgets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own budgets"
  ON public.budgets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own budgets"
  ON public.budgets FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own budgets"
  ON public.budgets FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- 5. CREATE STORAGE BUCKET FOR PROFILE PHOTOS
-- =====================================================

-- Run di Storage Section of Supabase Console:
-- 1. Klik "Buckets" di sidebar
-- 2. Klik "New bucket"
-- 3. Nama: "profiles"
-- 4. Pilih "Public bucket"
-- 5. Klik Create

-- Atau gunakan SQL (jika supported):
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('profiles', 'profiles', true);
```

---

## Langkah-Langkah Eksekusi

### Step 1: Setup Database Tables
1. Buka Supabase Console → SQL Editor
2. Klik "New query"
3. Copy-paste semua SQL script di atas
4. Klik **Run** (tombol biru di kanan bawah)
5. Tunggu hingga selesai (harus ada notifikasi "Success")

### Step 2: Setup Storage Bucket untuk Foto Profil
1. Buka Supabase Console
2. Klik **Storage** di sidebar
3. Klik **Create a new bucket**
4. Isi nama: `profiles`
5. Pilih **Public bucket** (agar bisa diakses dari app)
6. Klik **Create**

### Step 3: Verifikasi di Supabase Console
1. Buka **Database** → **Tables**
2. Cek bahwa ada tables: `users`, `accounts`, `categories`, `transactions`, `budgets`
3. Buka **Storage** → Cek ada bucket `profiles`

---

## Data Models yang Sesuai

### Users
- `id` (UUID) - Primary Key
- `email` (TEXT) - Email dari Auth
- `name` (TEXT) - Nama user
- `photo_url` (TEXT) - URL foto profil dari Storage
- `currency` (TEXT) - Mata uang default (IDR, USD, dll)
- `language` (TEXT) - Bahasa (id, en, dll)
- `date_format` (TEXT) - Format tanggal
- `theme_mode` (TEXT) - Light/Dark/System
- `created_at`, `updated_at` - Timestamps

### Accounts (Akun: Cash, Bank, E-wallet, Liabilities)
- `id` (UUID) - Primary Key
- `user_id` (UUID) - Foreign Key ke users
- `name` (TEXT) - Nama akun
- `type` (TEXT) - cash, bank, ewallet, liability
- `icon` (TEXT) - Emoji icon
- `color` (INTEGER) - Warna (format: 0xFFRRGGBB)
- `initial_balance` (DECIMAL) - Saldo awal
- `current_balance` (DECIMAL) - Saldo saat ini
- `is_active` (BOOLEAN) - Aktif atau tidak

### Categories
- `id` (UUID) - Primary Key
- `user_id` (UUID) - Foreign Key
- `name` (TEXT) - Nama kategori
- `type` (TEXT) - expense, income
- `icon` (TEXT) - Emoji icon
- `color` (INTEGER) - Warna
- `is_default` (BOOLEAN) - Kategori default atau custom

### Transactions
- `id` (UUID) - Primary Key
- `user_id` (UUID) - Foreign Key
- `account_id` (UUID) - Foreign Key ke accounts
- `category_id` (UUID) - Foreign Key ke categories
- `to_account_id` (UUID) - Untuk transfer (nullable)
- `amount` (DECIMAL) - Nominal
- `type` (TEXT) - income, expense, transfer
- `note` (TEXT) - Catatan (nullable)
- `date` (TIMESTAMPTZ) - Tanggal transaksi

### Budgets
- `id` (UUID) - Primary Key
- `user_id` (UUID) - Foreign Key
- `category_id` (UUID) - Foreign Key
- `amount` (DECIMAL) - Batas budget
- `period` (TEXT) - weekly, monthly, yearly
- `start_date`, `end_date` (TIMESTAMPTZ) - Periode budget

---

## REST API Endpoints

### Endpoints yang Bisa Digunakan (Auto-generated oleh Supabase)

**Base URL:** `https://omnftoowpnvmtbzfrcig.supabase.co/rest/v1`

#### Users
- `GET /users?select=*` - Ambil user login
- `PATCH /users?id=eq.USER_ID` - Update profile user

#### Accounts
- `GET /accounts?user_id=eq.USER_ID&order=created_at.desc` - Daftar akun
- `POST /accounts` - Buat akun baru
- `PATCH /accounts?id=eq.ACCOUNT_ID` - Update akun
- `DELETE /accounts?id=eq.ACCOUNT_ID` - Delete akun

#### Categories
- `GET /categories?user_id=eq.USER_ID&order=name.asc` - Daftar kategori
- `POST /categories` - Buat kategori
- `PATCH /categories?id=eq.CATEGORY_ID` - Update kategori
- `DELETE /categories?id=eq.CATEGORY_ID` - Delete kategori

#### Transactions
- `GET /transactions?user_id=eq.USER_ID&order=date.desc` - Daftar transaksi
- `GET /transactions?user_id=eq.USER_ID&date=gte.2025-01-01` - Filter by date
- `POST /transactions` - Buat transaksi
- `PATCH /transactions?id=eq.TRANSACTION_ID` - Update transaksi
- `DELETE /transactions?id=eq.TRANSACTION_ID` - Delete transaksi

#### Budgets
- `GET /budgets?user_id=eq.USER_ID` - Daftar budget
- `POST /budgets` - Buat budget
- `PATCH /budgets?id=eq.BUDGET_ID` - Update budget
- `DELETE /budgets?id=eq.BUDGET_ID` - Delete budget

---

## Contoh Query Supabase di Flutter

```dart
// Get user profile
final user = await _supabase
  .from('users')
  .select()
  .eq('id', userId)
  .single();

// Get all accounts for user
final accounts = await _supabase
  .from('accounts')
  .select()
  .eq('user_id', userId)
  .order('created_at', ascending: false);

// Insert new transaction
await _supabase
  .from('transactions')
  .insert({
    'user_id': userId,
    'account_id': accountId,
    'category_id': categoryId,
    'amount': amount,
    'type': 'expense',
    'date': DateTime.now().toIso8601String(),
  });

// Update account balance
await _supabase
  .from('accounts')
  .update({'current_balance': newBalance})
  .eq('id', accountId);
```

---

## Security Best Practices

✅ **RLS Enabled** - Setiap user hanya bisa akses data miliknya sendiri
✅ **Auth Required** - Semua endpoints memerlukan authentication
✅ **Storage Public** - Foto profil bisa diakses public, tapi upload hanya dari app auth
✅ **Cascading Delete** - Delete user otomatis delete semua data miliknya

---

## Troubleshooting

### Error: "new row violates row-level security policy"
- Pastikan `user_id` di record sama dengan `auth.uid()` yang login

### Error: "relation does not exist"
- Pastikan SQL script sudah dijalankan sampai selesai di SQL Editor

### Foto tidak bisa diupload
- Pastikan bucket `profiles` sudah dibuat dan berstatus Public
- Cek permission di Storage policies

### Data tidak muncul di app
- Cek network request di Developer Tools (Chrome DevTools)
- Pastikan `select=*` di query
- Pastikan auth token valid

---

## Selesai! ✅

Sekarang database Supabase sudah siap untuk Money Manager app. Aplikasi bisa langsung:
- Login/Register dengan Supabase Auth
- Create/Read/Update/Delete Accounts, Categories, Transactions, Budgets
- Upload foto profil ke Storage
- Semua data aman dengan RLS policies per user

