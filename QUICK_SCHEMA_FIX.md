# ⚡ QUICK FIX REFERENCE - Copy Paste Schema Sekarang

## 🚀 LANGKAH TERCEPAT (5 MENIT)

### 1️⃣ Buka SQL Editor Supabase
https://omnftoowpnvmtbzfrcig.supabase.co → SQL Editor → New Query

### 2️⃣ Copy & Run Script Ini

```sql
-- Drop existing tables (jika ada)
DROP TABLE IF EXISTS public.budgets CASCADE;
DROP TABLE IF EXISTS public.transactions CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.accounts CASCADE;
DROP TABLE IF EXISTS public.user_profiles CASCADE;

-- Create Users Table
CREATE TABLE public.users (
  id uuid NOT NULL DEFAULT auth.uid(),
  email text NOT NULL UNIQUE,
  name text NOT NULL,
  photo_url text,
  currency text DEFAULT 'IDR',
  language text DEFAULT 'id',
  date_format text DEFAULT 'dd/MM/yyyy',
  theme_mode text DEFAULT 'system',
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);

-- ✅ FIXED: Accounts - id TEXT, type with CHECK, color -1049552127
CREATE TABLE public.accounts (
  id text NOT NULL,
  user_id uuid NOT NULL,
  name text NOT NULL,
  type text NOT NULL DEFAULT 'cash' CHECK (type IN ('cash', 'bank', 'ewallet', 'liability')),
  icon text NOT NULL,
  color integer NOT NULL DEFAULT (-1049552127),
  initial_balance numeric NOT NULL DEFAULT 0,
  current_balance numeric NOT NULL DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT accounts_pkey PRIMARY KEY (id),
  CONSTRAINT accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- ✅ FIXED: Categories - id TEXT, type with CHECK, color -1049552127
CREATE TABLE public.categories (
  id text NOT NULL,
  user_id uuid NOT NULL,
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('expense', 'income')),
  icon text NOT NULL,
  color integer NOT NULL DEFAULT (-1049552127),
  is_default boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT categories_pkey PRIMARY KEY (id),
  CONSTRAINT categories_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- ✅ FIXED: Transactions - id TEXT, account_id TEXT, category_id TEXT, type with CHECK
CREATE TABLE public.transactions (
  id text NOT NULL,
  user_id uuid NOT NULL,
  account_id text NOT NULL,
  category_id text NOT NULL,
  to_account_id text,
  amount numeric NOT NULL,
  type text NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
  note text,
  date timestamp with time zone NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT transactions_pkey PRIMARY KEY (id),
  CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- ✅ FIXED: Budgets - id TEXT, category_id TEXT, period with CHECK
CREATE TABLE public.budgets (
  id text NOT NULL,
  user_id uuid NOT NULL,
  category_id text NOT NULL,
  amount numeric NOT NULL,
  period text NOT NULL DEFAULT 'monthly' CHECK (period IN ('weekly', 'monthly', 'yearly')),
  start_date timestamp with time zone NOT NULL,
  end_date timestamp with time zone NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT budgets_pkey PRIMARY KEY (id),
  CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- Create Indexes
CREATE INDEX idx_accounts_user_id ON public.accounts(user_id);
CREATE INDEX idx_categories_user_id ON public.categories(user_id);
CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_account_id ON public.transactions(account_id);
CREATE INDEX idx_transactions_category_id ON public.transactions(category_id);
CREATE INDEX idx_transactions_date ON public.transactions(date DESC);
CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_budgets_category_id ON public.budgets(category_id);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Accounts
CREATE POLICY "Users can view own accounts" ON public.accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own accounts" ON public.accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own accounts" ON public.accounts FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own accounts" ON public.accounts FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for Categories
CREATE POLICY "Users can view own categories" ON public.categories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own categories" ON public.categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own categories" ON public.categories FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own categories" ON public.categories FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for Transactions
CREATE POLICY "Users can view own transactions" ON public.transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own transactions" ON public.transactions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own transactions" ON public.transactions FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own transactions" ON public.transactions FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for Budgets
CREATE POLICY "Users can view own budgets" ON public.budgets FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own budgets" ON public.budgets FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own budgets" ON public.budgets FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own budgets" ON public.budgets FOR DELETE USING (auth.uid() = user_id);
```

### 3️⃣ Klik RUN
Tunggu sampai "Query executed successfully"

### 4️⃣ Test di Aplikasi
- Create Account → Verify masuk di Supabase ✅
- Add Transaction → Verify masuk di Supabase ✅
- Add Category → Verify masuk di Supabase ✅

---

## 🔑 KEY DIFFERENCES (Old vs New)

| Field | BEFORE (❌ WRONG) | AFTER (✅ CORRECT) | Aplikasi |
|-------|---|---|---|
| **accounts.id** | uuid | TEXT | DateTime.millisecondsSinceEpoch |
| **accounts.type** | text | text + CHECK | enum: cash\|bank\|ewallet\|liability |
| **accounts.color** | bigint '4284704497' | integer -1049552127 | Color.value int |
| **categories.id** | uuid | TEXT | DateTime.millisecondsSinceEpoch |
| **categories.type** | text | text + CHECK | enum: expense\|income |
| **categories.color** | bigint '4284704497' | integer -1049552127 | Color.value int |
| **transactions.id** | uuid | TEXT | DateTime.millisecondsSinceEpoch |
| **transactions.account_id** | uuid | TEXT | String accountId |
| **transactions.category_id** | uuid | TEXT | String categoryId |
| **transactions.type** | text | text + CHECK | enum: income\|expense\|transfer |
| **budgets.id** | uuid | TEXT | DateTime.millisecondsSinceEpoch |
| **budgets.category_id** | uuid | TEXT | String categoryId |
| **budgets.period** | text | text + CHECK | String: weekly\|monthly\|yearly |

---

## ⚠️ IMPORTANT NOTES

1. **ID Format:** Database expects TEXT (string), aplikasi kirim millisecondsSinceEpoch string
   ```dart
   // ✅ CORRECT
   id: DateTime.now().millisecondsSinceEpoch.toString()  // "1705862400123"
   
   // ❌ WRONG
   id: Uuid().v4()  // "550e8400-e29b-41d4-a716-446655440000"
   ```

2. **Color Value:** Database expects INTEGER, aplikasi kirim Color.value
   ```dart
   // ✅ CORRECT - Color.value returns int
   color: Color(0xFF6366F1).value  // -1049552127
   
   // ❌ WRONG
   color: "0xFF6366F1"  // String, not integer
   ```

3. **Type Validation:** Database sekarang CHECK valid enums
   ```dart
   // ✅ CORRECT - salah satu dari enum values
   type: 'income'  // or 'expense', 'transfer'
   
   // ❌ WRONG
   type: 'unknown'  // INSERT FAIL - violates CHECK constraint
   ```

4. **User Isolation:** RLS policies ensure user hanya bisa lihat data mereka

---

## 🎯 AFTER SCHEMA SETUP

Next steps:

1. ✅ Database schema sudah CORRECT
2. ⏳ Create Repository classes
3. ⏳ Update Provider untuk Supabase API
4. ⏳ Test all input flows
5. ⏳ Create Storage bucket untuk foto

Lihat `DATABASE_FIXES_EXPLANATION.md` untuk detail lengkap.

---
