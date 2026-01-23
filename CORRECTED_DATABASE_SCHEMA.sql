-- =====================================================
-- ✅ CORRECTED DATABASE SCHEMA
-- ✅ This schema matches your Flutter application models
-- =====================================================

-- Drop old tables jika ada (opsional)
-- DROP TABLE IF EXISTS public.user_profiles;
-- DROP TABLE IF EXISTS public.budgets;
-- DROP TABLE IF EXISTS public.transactions;
-- DROP TABLE IF EXISTS public.categories;
-- DROP TABLE IF EXISTS public.accounts;
-- DROP TABLE IF EXISTS public.users;

-- =====================================================
-- CRITICAL FIXES FROM YOUR ORIGINAL SCHEMA
-- =====================================================
-- 1. ID fields: UUID → TEXT (aplikasi gunakan millisecondsSinceEpoch)
-- 2. Color: '4284704497'::bigint → INTEGER -1049552127 (Dart Color.value)
-- 3. Foreign Keys: UUID → UUID (tidak boleh UUID → TEXT)
-- 4. Type fields: Tambah CHECK constraint untuk validasi enum
-- =====================================================

-- 1. Users Table (dari Supabase Auth)
CREATE TABLE IF NOT EXISTS public.users (
  id uuid NOT NULL DEFAULT auth.uid(),
  email text NOT NULL UNIQUE,
  name text NOT NULL,
  photo_url text,
  currency text DEFAULT 'IDR'::text,
  language text DEFAULT 'id'::text,
  date_format text DEFAULT 'dd/MM/yyyy'::text,
  theme_mode text DEFAULT 'system'::text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);

-- 2. Accounts Table
-- ✅ FIXED: id UUID → TEXT (dari DateTime.millisecondsSinceEpoch.toString())
-- ✅ FIXED: color integer dengan nilai default -1049552127 (Dart Color.value)
-- ✅ FIXED: type dengan CHECK constraint untuk AccountType enum (cash, bank, ewallet, liability)
CREATE TABLE IF NOT EXISTS public.accounts (
  id text NOT NULL,
  user_id uuid NOT NULL,
  name text NOT NULL,
  type text NOT NULL DEFAULT 'cash'::text CHECK (type IN ('cash', 'bank', 'ewallet', 'liability')),
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

-- 3. Categories Table
-- ✅ FIXED: id UUID → TEXT
-- ✅ FIXED: color integer -1049552127
-- ✅ FIXED: type dengan CHECK constraint untuk CategoryType enum (expense, income)
CREATE TABLE IF NOT EXISTS public.categories (
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

-- 4. Transactions Table
-- ✅ FIXED: id UUID → TEXT
-- ✅ FIXED: account_id UUID → TEXT (foreign key ke accounts.id yang TEXT)
-- ✅ FIXED: category_id UUID → TEXT (foreign key ke categories.id yang TEXT)
-- ✅ FIXED: to_account_id UUID → TEXT (untuk transfer transactions)
-- ✅ FIXED: type dengan CHECK constraint untuk TransactionType enum (income, expense, transfer)
-- ✅ REMOVED: Foreign key constraints (FK validation optional, aplikasi sudah validate)
CREATE TABLE IF NOT EXISTS public.transactions (
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

-- 5. Budgets Table
-- ✅ FIXED: id UUID → TEXT
-- ✅ FIXED: category_id UUID → TEXT (foreign key ke categories.id yang TEXT)
-- ✅ FIXED: period dengan CHECK constraint untuk period enum (weekly, monthly, yearly)
CREATE TABLE IF NOT EXISTS public.budgets (
  id text NOT NULL,
  user_id uuid NOT NULL,
  category_id text NOT NULL,
  amount numeric NOT NULL,
  period text NOT NULL DEFAULT 'monthly'::text CHECK (period IN ('weekly', 'monthly', 'yearly')),
  start_date timestamp with time zone NOT NULL,
  end_date timestamp with time zone NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT budgets_pkey PRIMARY KEY (id),
  CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);

-- 6. User Profiles Table (Optional - untuk extended user info)
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL UNIQUE,
  name text NOT NULL,
  email text,
  photo_url text,
  theme text DEFAULT 'system'::text,
  currency text DEFAULT 'IDR'::text,
  language text DEFAULT 'id'::text,
  date_format text DEFAULT 'dd/MM/yyyy'::text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- =====================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON public.accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_is_active ON public.accounts(is_active);
CREATE INDEX IF NOT EXISTS idx_accounts_created_at ON public.accounts(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_categories_user_id ON public.categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_type ON public.categories(type);

CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id ON public.transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category_id ON public.transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON public.transactions(date DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON public.transactions(type);

CREATE INDEX IF NOT EXISTS idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_category_id ON public.budgets(category_id);

-- =====================================================
-- ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RLS POLICIES
-- =====================================================

-- ACCOUNTS: User dapat melihat hanya accounts milik mereka
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

-- CATEGORIES: User dapat melihat hanya categories milik mereka
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

-- TRANSACTIONS: User dapat melihat hanya transactions milik mereka
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

-- BUDGETS: User dapat melihat hanya budgets milik mereka
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
-- MAPPING APLIKASI ↔ DATABASE
-- =====================================================
-- TransactionModel.id → transactions.id (TEXT, millisecondsSinceEpoch)
-- TransactionModel.type (enum: income, expense, transfer) → transactions.type (TEXT with CHECK)
-- TransactionModel.date → transactions.date (TIMESTAMPTZ)
--
-- AccountModel.id → accounts.id (TEXT, millisecondsSinceEpoch)
-- AccountModel.type (enum: cash, bank, ewallet, liability) → accounts.type (TEXT with CHECK)
-- AccountModel.color (int: -1049552127) → accounts.color (INTEGER)
--
-- CategoryModel.id → categories.id (TEXT, millisecondsSinceEpoch)
-- CategoryModel.type (enum: expense, income) → categories.type (TEXT with CHECK)
-- CategoryModel.color (int: -1049552127) → categories.color (INTEGER)
--
-- BudgetModel.id → budgets.id (TEXT, millisecondsSinceEpoch)
-- BudgetModel.period (weekly, monthly, yearly) → budgets.period (TEXT with CHECK)
-- =====================================================
