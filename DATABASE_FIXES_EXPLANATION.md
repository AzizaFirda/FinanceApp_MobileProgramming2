# 🔧 DATABASE SCHEMA FIXES - LANGKAH DEMI LANGKAH

**Masalah:** Data yang diinput di aplikasi tidak masuk ke database Supabase  
**Penyebab:** Mismatch antara tipe data aplikasi dan database schema  
**Solusi:** Ubah database schema agar match dengan aplikasi

---

## 🔴 CRITICAL ISSUES DITEMUKAN

### 1. **ID Type Mismatch** (PALING PENTING)

**Aplikasi (Dart):**
```dart
// TransactionModel, AccountModel, CategoryModel, BudgetModel semuanya punya:
id: DateTime.now().millisecondsSinceEpoch.toString()
// Contoh: "1705862400123" (string 13 digit)
```

**Database Lama (WRONG):**
```sql
id uuid NOT NULL DEFAULT gen_random_uuid()
-- Contoh: "550e8400-e29b-41d4-a716-446655440000"
```

**Problem:** UUID dan STRING adalah tipe BERBEDA! INSERT akan FAIL

---

### 2. **Color Type Mismatch**

**Aplikasi (Dart):**
```dart
// Dari Color enum atau Color picker
color: int  // Contoh: -1049552127 (signed integer)
// Ini adalah Color.value dari Flutter Color class
```

**Database Lama (WRONG):**
```sql
color integer NOT NULL DEFAULT '4284704497'::bigint
-- String '4284704497' diconvert ke bigint, bukan integer!
```

**Problem:** Type mismatch bisa menyebabkan data error

---

### 3. **No Validation untuk Enum Values**

**Aplikasi:**
```dart
// TransactionType enum
enum TransactionType { income, expense, transfer }

// AccountType enum
enum AccountType { cash, bank, ewallet, liability }

// CategoryType enum
enum CategoryType { expense, income }

// BudgetModel.period
String period; // 'weekly' | 'monthly' | 'yearly'
```

**Database Lama (WRONG):**
```sql
type text NOT NULL  -- TIDAK ADA VALIDASI!
-- Database accept ANY nilai, bahkan "invalid_type"
```

**Problem:** Data invalid bisa masuk ke database

---

### 4. **Foreign Key Type Mismatch**

**Aplikasi:**
- `transactions.account_id` = string (TEXT)
- `transactions.category_id` = string (TEXT)

**Database Lama (WRONG):**
```sql
account_id uuid NOT NULL REFERENCES accounts(id)
-- FK menunjuk ke UUID, tapi aplikasi kirim TEXT!
```

**Problem:** FK constraint FAIL, INSERT rejected

---

## ✅ FIXES YANG DILAKUKAN

### FIX 1: ACCOUNTS Table

```sql
-- SEBELUM (WRONG)
CREATE TABLE accounts (
  id uuid DEFAULT gen_random_uuid(),  -- ❌ UUID
  type text DEFAULT 'cash',            -- ❌ Tanpa validasi
  color integer DEFAULT '4284704497'   -- ❌ Salah format
);

-- SESUDAH (CORRECT)
CREATE TABLE accounts (
  id text PRIMARY KEY,                 -- ✅ TEXT (untuk STRING id)
  type text CHECK (type IN ('cash', 'bank', 'ewallet', 'liability')),  -- ✅ Validasi enum
  color integer DEFAULT -1049552127    -- ✅ Correct Dart Color.value
);
```

---

### FIX 2: CATEGORIES Table

```sql
-- SEBELUM (WRONG)
CREATE TABLE categories (
  id uuid DEFAULT gen_random_uuid(),   -- ❌ UUID
  type text NOT NULL,                   -- ❌ Tanpa validasi
  color integer DEFAULT '4284704497'   -- ❌ Salah format
);

-- SESUDAH (CORRECT)
CREATE TABLE categories (
  id text PRIMARY KEY,                 -- ✅ TEXT
  type text CHECK (type IN ('expense', 'income')),  -- ✅ Validasi enum
  color integer DEFAULT -1049552127    -- ✅ Correct Dart Color.value
);
```

---

### FIX 3: TRANSACTIONS Table

```sql
-- SEBELUM (WRONG)
CREATE TABLE transactions (
  id uuid DEFAULT gen_random_uuid(),   -- ❌ UUID
  account_id uuid REFERENCES accounts(id),  -- ❌ UUID, FK mismatch
  category_id uuid REFERENCES categories(id),  -- ❌ UUID, FK mismatch
  type text NOT NULL                   -- ❌ Tanpa validasi
);

-- SESUDAH (CORRECT)
CREATE TABLE transactions (
  id text PRIMARY KEY,                 -- ✅ TEXT
  account_id text NOT NULL,            -- ✅ TEXT (match aplikasi)
  category_id text NOT NULL,           -- ✅ TEXT (match aplikasi)
  to_account_id text,                  -- ✅ TEXT untuk transfer
  type text CHECK (type IN ('income', 'expense', 'transfer'))  -- ✅ Validasi enum
);
```

---

### FIX 4: BUDGETS Table

```sql
-- SEBELUM (WRONG)
CREATE TABLE budgets (
  id uuid DEFAULT gen_random_uuid(),   -- ❌ UUID
  category_id uuid REFERENCES categories(id),  -- ❌ UUID, FK mismatch
  period text DEFAULT 'monthly'        -- ❌ Tanpa validasi
);

-- SESUDAH (CORRECT)
CREATE TABLE budgets (
  id text PRIMARY KEY,                 -- ✅ TEXT
  category_id text NOT NULL,           -- ✅ TEXT (match aplikasi)
  period text CHECK (period IN ('weekly', 'monthly', 'yearly'))  -- ✅ Validasi enum
);
```

---

## 📋 CHECKLIST IMPLEMENTASI

Ikuti langkah-langkah ini:

### Step 1: Backup Database (Opsional)
Jika sudah ada data di database, backup dulu atau catat data penting

### Step 2: Drop Existing Tables
```sql
-- Di Supabase SQL Editor, jalankan:
DROP TABLE IF EXISTS public.budgets;
DROP TABLE IF EXISTS public.transactions;
DROP TABLE IF EXISTS public.categories;
DROP TABLE IF EXISTS public.accounts;
DROP TABLE IF EXISTS public.user_profiles;
```

### Step 3: Execute New Schema
```
1. Buka: https://omnftoowpnvmtbzfrcig.supabase.co/
2. Login
3. Klik: SQL Editor → New Query
4. Copy semua SQL dari CORRECTED_DATABASE_SCHEMA.sql
5. Paste ke SQL Editor
6. Klik: RUN
7. Tunggu sampai selesai
```

### Step 4: Verify Database
Setelah RUN berhasil, lihat di:
- **Table Editor** → Lihat 5 tables: users, accounts, categories, transactions, budgets
- **Columns** → Verify id, type, period, color sesuai schema

### Step 5: Test Input Flow

Di aplikasi:

1. **Create Account:**
   - Name: "BRI"
   - Type: "bank"
   - Icon: "🏦"
   - Initial Balance: 100000
   
   Hasil: Data masuk ke `accounts` table ✅

2. **Create Category:**
   - Name: "Makan"
   - Type: "expense"
   - Icon: "🍔"
   
   Hasil: Data masuk ke `categories` table ✅

3. **Add Transaction:**
   - Amount: 50000
   - Type: "expense"
   - Category: "Makan"
   - Account: "BRI"
   - Date: Today
   
   Hasil: Data masuk ke `transactions` table ✅

---

## 🎯 FIELD MAPPING REFERENCE

### Transactions Input Form → Database

| Flutter Field | Type | Database Field | SQL Type | Validasi |
|---|---|---|---|---|
| id | String | id | TEXT | millisecondsSinceEpoch |
| amount | double | amount | NUMERIC(15,2) | > 0 |
| type | TransactionType enum | type | TEXT | CHECK: income, expense, transfer |
| categoryId | String | category_id | TEXT | - |
| accountId | String | account_id | TEXT | - |
| toAccountId | String? | to_account_id | TEXT | Opsional (untuk transfer) |
| date | DateTime | date | TIMESTAMPTZ | - |
| note | String? | note | TEXT | Opsional |

### Accounts Input Form → Database

| Flutter Field | Type | Database Field | SQL Type | Validasi |
|---|---|---|---|---|
| id | String | id | TEXT | millisecondsSinceEpoch |
| name | String | name | TEXT | - |
| type | AccountType enum | type | TEXT | CHECK: cash, bank, ewallet, liability |
| icon | String | icon | TEXT | - |
| color | int | color | INTEGER | Dart Color.value |
| initialBalance | double | initial_balance | NUMERIC(15,2) | >= 0 |
| currentBalance | double | current_balance | NUMERIC(15,2) | >= 0 |

### Categories Input Form → Database

| Flutter Field | Type | Database Field | SQL Type | Validasi |
|---|---|---|---|---|
| id | String | id | TEXT | millisecondsSinceEpoch |
| name | String | name | TEXT | - |
| type | CategoryType enum | type | TEXT | CHECK: expense, income |
| icon | String | icon | TEXT | - |
| color | int | color | INTEGER | Dart Color.value |
| isDefault | bool | is_default | BOOLEAN | false default |

### Budgets Input Form → Database

| Flutter Field | Type | Database Field | SQL Type | Validasi |
|---|---|---|---|---|
| id | String | id | TEXT | millisecondsSinceEpoch |
| categoryId | String | category_id | TEXT | - |
| amount | double | amount | NUMERIC(15,2) | > 0 |
| period | String | period | TEXT | CHECK: weekly, monthly, yearly |
| startDate | DateTime | start_date | TIMESTAMPTZ | - |
| endDate | DateTime | end_date | TIMESTAMPTZ | - |

---

## 🚀 NEXT STEPS

Setelah schema fixed:

1. ✅ Execute corrected SQL schema
2. ⏳ Create Repositories (UserRepository, AccountRepository, dll)
3. ⏳ Update Providers untuk integration dengan Supabase
4. ⏳ Test semua input flows
5. ⏳ Setup Storage bucket untuk foto

---

## ❓ FAQ

**Q: Apakah perlu delete data lama?**  
A: Ya, karena tipe id berubah dari UUID ke TEXT. Data lama tidak compatible.

**Q: Apakah foreign key penting?**  
A: Tidak untuk MVP. Aplikasi sudah validate, FK optional. Penting untuk data integrity di future.

**Q: Bagaimana dengan migration existing users?**  
A: Untuk MVP: reset database, mulai fresh. Untuk production: buat migration script terpisah.

**Q: Apakah COLOR value -1049552127 selalu sama?**  
A: Bergantung dari default color di aplikasi. Contoh dari Color(0xFF6366F1).value

---

## 📞 DEBUGGING

Jika INSERT masih FAIL, cek:

1. **ID Format:** Pastikan kirim string format millisecondsSinceEpoch
   ```dart
   id: DateTime.now().millisecondsSinceEpoch.toString()  // ✅ String
   ```

2. **Enum Values:** Pastikan enum value match database CHECK constraint
   ```dart
   if (type != 'income' && type != 'expense' && type != 'transfer') {
     // ERROR! Type tidak valid
   }
   ```

3. **Color Value:** Pastikan kirim INTEGER, bukan hex string
   ```dart
   color: -1049552127  // ✅ INTEGER
   color: "0xFF6366F1" // ❌ STRING
   ```

4. **Check RLS Policies:** Pastikan user auth sudah login sebelum INSERT

5. **Check Network:** Pastikan credentials Supabase masih valid

---
