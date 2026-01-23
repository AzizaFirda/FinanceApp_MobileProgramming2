# 🚀 Supabase Integration Setup

## Informasi Koneksi

```
URL: https://omnftoowpnvmtbzfrcig.supabase.co
ANON KEY: sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq
```

## 📋 Database Tables yang Diperlukan

### 1. Users Table
```sql
create table public.users (
  id uuid primary key references auth.users on delete cascade,
  email text unique not null,
  name text,
  photo_url text,
  currency text default 'IDR',
  language text default 'id',
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table public.users enable row level security;

-- Policy: Users dapat melihat profil mereka sendiri
create policy "Users can view own profile"
  on public.users for select
  using (auth.uid() = id);

-- Policy: Users dapat update profil mereka sendiri
create policy "Users can update own profile"
  on public.users for update
  using (auth.uid() = id);
```

### 2. Transactions Table
```sql
create table public.transactions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references public.users(id) on delete cascade,
  amount decimal(15,2) not null,
  type text not null check (type in ('income', 'expense')),
  category_id text,
  account_id text,
  date timestamp with time zone not null,
  note text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table public.transactions enable row level security;

-- Policy: Users dapat melihat transaksi mereka sendiri
create policy "Users can view own transactions"
  on public.transactions for select
  using (auth.uid() = user_id);

-- Policy: Users dapat insert transaksi mereka sendiri
create policy "Users can insert own transactions"
  on public.transactions for insert
  with check (auth.uid() = user_id);

-- Policy: Users dapat update transaksi mereka sendiri
create policy "Users can update own transactions"
  on public.transactions for update
  using (auth.uid() = user_id);

-- Policy: Users dapat delete transaksi mereka sendiri
create policy "Users can delete own transactions"
  on public.transactions for delete
  using (auth.uid() = user_id);
```

### 3. Accounts Table
```sql
create table public.accounts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references public.users(id) on delete cascade,
  name text not null,
  type text not null check (type in ('cash', 'bank', 'ewallet', 'liability')),
  color integer,
  icon text,
  current_balance decimal(15,2) default 0,
  initial_balance decimal(15,2) default 0,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table public.accounts enable row level security;

-- Policies (sama seperti transactions)
create policy "Users can view own accounts"
  on public.accounts for select
  using (auth.uid() = user_id);

create policy "Users can manage own accounts"
  on public.accounts for all
  using (auth.uid() = user_id);
```

### 4. Categories Table
```sql
create table public.categories (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references public.users(id) on delete cascade,
  name text not null,
  type text not null check (type in ('income', 'expense')),
  color integer,
  icon text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table public.categories enable row level security;

-- Policies
create policy "Users can view own categories"
  on public.categories for select
  using (auth.uid() = user_id);

create policy "Users can manage own categories"
  on public.categories for all
  using (auth.uid() = user_id);
```

## 🔧 Configuration

Supabase sudah di-initialize di `main.dart`:

```dart
await Supabase.initialize(
  url: 'https://omnftoowpnvmtbzfrcig.supabase.co',
  anonKey: 'sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq',
);
```

## 📱 Auth Methods yang Tersedia

### SignUp
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.register(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
);
```

### SignIn
```dart
await authProvider.login(
  email: 'user@example.com',
  password: 'password123',
);
```

### SignOut
```dart
await authProvider.logout();
```

### Reset Password
```dart
final authService = AuthService();
final result = await authService.resetPassword(
  email: 'user@example.com',
);
```

## 🔒 Security

- **RLS (Row Level Security)** enabled untuk semua tables
- **Anon Key** hanya untuk public access (auth)
- **Service Role Key** diperlukan untuk admin operations
- Sensitive operations dapat menggunakan JWT tokens

## 📚 API Reference

### AuthService Methods
```dart
// Auth
Future<Map<String, dynamic>> signUp({...})
Future<Map<String, dynamic>> signIn({...})
Future<void> signOut()
Future<Map<String, dynamic>> resetPassword({...})

// User Data
Future<Map<String, dynamic>?> getUserData(String uid)
Future<void> updateUserData(String uid, Map<String, dynamic> data)

// Verification
bool get isEmailVerified
Future<void> sendEmailVerification()

// Account Management
Future<Map<String, dynamic>> deleteAccount()

// Properties
User? get currentUser
String? get currentUserId
bool get isAuthenticated
Session? get session
Stream<AuthState> get authStateChanges
```

## 🔗 Integrasi dengan Providers

Auth state otomatis di-sync dengan:
- **AuthProvider** → Handle login/register
- **TransactionProvider** → Filter by user_id
- **AccountProvider** → Filter by user_id
- **CategoryProvider** → Filter by user_id
- **SettingsProvider** → Load user preferences

## 🚨 Troubleshooting

### Error: "PGRST116" (Row not found)
- Gunakan `.maybeSingle()` atau handle dengan try-catch
- Sudah diterapkan di `getUserData()`

### Error: "RLS policy violation"
- Pastikan user authenticated
- Check user_id matches dengan auth.uid()
- Verify RLS policies di Supabase console

### Auth tidak tersimpan
- Supabase otomatis persist session
- Check secure storage configuration untuk native

## 📖 Dokumentasi Lengkap
- https://supabase.com/docs/guides/auth
- https://supabase.com/docs/guides/api
- https://supabase.com/docs/guides/database

---

**Status**: ✅ Integration Complete
**Last Updated**: January 22, 2026
