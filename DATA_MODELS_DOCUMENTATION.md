# 📊 Data Models & Schema Documentation

## Overview
Dokumentasi lengkap semua data models dan schema yang ada di Money Manager app.

---

## Entity Relationship Diagram

```
┌─────────────────────┐
│      users          │ (Auth from Supabase Auth)
├─────────────────────┤
│ id (UUID)           │◄─────────────┐
│ email               │              │
│ created_at          │              │
│ updated_at          │              │
└─────────────────────┘              │
         │ (1:N)                     │
         │                           │
    ┌────┴────────────┬──────────────┼──────────────┐
    │                 │              │              │
    ▼                 ▼              ▼              ▼
┌──────────┐  ┌──────────────┐  ┌──────────┐  ┌────────┐
│ accounts │  │ categories   │  │budgets   │  │profile │
│          │  │              │  │          │  │(auth)  │
└──────────┘  └──────────────┘  └──────────┘  └────────┘
    │ (1:N)        │ (1:N)
    │              │
    │              ▼
    │      ┌─────────────────────┐
    └─────►│   transactions      │
           │                     │
           │ has: amount, type,  │
           │       account, cat  │
           └─────────────────────┘
```

---

## 1. Users Table

**Purpose:** Menyimpan informasi user dari Supabase Auth

```sql
CREATE TABLE users (
  id uuid NOT NULL PRIMARY KEY REFERENCES auth.users(id),
  email text NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key, auto dari Supabase Auth |
| `email` | text | Email user (unique) |
| `created_at` | timestamp | Waktu account dibuat |
| `updated_at` | timestamp | Waktu terakhir diupdate |

### Contoh Data
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-20T14:45:00Z"
}
```

### Related Model di Dart
```dart
class UserProfileModel {
  final String id;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
```

---

## 2. Accounts Table

**Purpose:** Menyimpan rekening/wallet user (BRI, BCA, Cash, etc.)

```sql
CREATE TABLE accounts (
  id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name text NOT NULL,
  account_type text NOT NULL,
  balance numeric NOT NULL DEFAULT 0,
  currency text NOT NULL DEFAULT 'IDR',
  is_default boolean DEFAULT false,
  color text NOT NULL DEFAULT '#6366F1',
  icon_name text NOT NULL DEFAULT 'bank',
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `user_id` | UUID | Foreign key ke users |
| `name` | text | Nama account (BRI, BCA, E-Wallet) |
| `account_type` | text | bank, cash, e_wallet, etc |
| `balance` | numeric | Saldo saat ini |
| `currency` | text | Mata uang (IDR, USD, etc) |
| `is_default` | boolean | Account utama? |
| `color` | text | Hex color (#6366F1) |
| `icon_name` | text | Icon identifier |
| `notes` | text | Catatan/keterangan |
| `created_at` | timestamp | Dibuat kapan |
| `updated_at` | timestamp | Diupdate kapan |

### Contoh Data
```json
{
  "id": "650e8400-e29b-41d4-a716-446655440001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "BRI Gajian",
  "account_type": "bank",
  "balance": 5000000,
  "currency": "IDR",
  "is_default": true,
  "color": "#6366F1",
  "icon_name": "bank",
  "notes": "Rekening utama",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-20T14:45:00Z"
}
```

### Related Model di Dart
```dart
class AccountModel {
  final String id;
  final String userId;
  final String name;
  final String accountType;
  final double balance;
  final String currency;
  final bool isDefault;
  final String color;
  final String iconName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.accountType,
    required this.balance,
    required this.currency,
    required this.isDefault,
    required this.color,
    required this.iconName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      accountType: json['account_type'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'IDR',
      isDefault: json['is_default'] as bool? ?? false,
      color: json['color'] as String? ?? '#6366F1',
      iconName: json['icon_name'] as String? ?? 'bank',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'account_type': accountType,
    'balance': balance,
    'currency': currency,
    'is_default': isDefault,
    'color': color,
    'icon_name': iconName,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
```

---

## 3. Categories Table

**Purpose:** Menyimpan kategori pengeluaran/pemasukan

```sql
CREATE TABLE categories (
  id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name text NOT NULL,
  category_type text NOT NULL,
  color text NOT NULL DEFAULT '#8B5CF6',
  icon_name text NOT NULL DEFAULT 'shopping',
  is_default boolean DEFAULT false,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `user_id` | UUID | Foreign key ke users |
| `name` | text | Nama kategori (Makan, Transport, etc) |
| `category_type` | text | income, expense, transfer |
| `color` | text | Hex color (#8B5CF6) |
| `icon_name` | text | Icon identifier |
| `is_default` | boolean | Kategori bawaan? |
| `created_at` | timestamp | Dibuat kapan |
| `updated_at` | timestamp | Diupdate kapan |

### Contoh Data
```json
{
  "id": "750e8400-e29b-41d4-a716-446655440002",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Makan & Minum",
  "category_type": "expense",
  "color": "#8B5CF6",
  "icon_name": "utensils",
  "is_default": true,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-20T14:45:00Z"
}
```

### Related Model di Dart
```dart
class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String categoryType;
  final String color;
  final String iconName;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.categoryType,
    required this.color,
    required this.iconName,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      categoryType: json['category_type'] as String,
      color: json['color'] as String? ?? '#8B5CF6',
      iconName: json['icon_name'] as String? ?? 'shopping',
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'category_type': categoryType,
    'color': color,
    'icon_name': iconName,
    'is_default': isDefault,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
```

---

## 4. Transactions Table

**Purpose:** Menyimpan setiap transaksi (income, expense, transfer)

```sql
CREATE TABLE transactions (
  id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  amount numeric NOT NULL,
  transaction_type text NOT NULL,
  description text,
  notes text,
  transaction_date date NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `user_id` | UUID | Foreign key ke users |
| `account_id` | UUID | Foreign key ke accounts |
| `category_id` | UUID | Foreign key ke categories |
| `amount` | numeric | Jumlah transaksi |
| `transaction_type` | text | income, expense, transfer |
| `description` | text | Deskripsi singkat |
| `notes` | text | Catatan detail |
| `transaction_date` | date | Tanggal transaksi |
| `created_at` | timestamp | Dicatat kapan |
| `updated_at` | timestamp | Diupdate kapan |

### Contoh Data
```json
{
  "id": "850e8400-e29b-41d4-a716-446655440003",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "account_id": "650e8400-e29b-41d4-a716-446655440001",
  "category_id": "750e8400-e29b-41d4-a716-446655440002",
  "amount": 75000,
  "transaction_type": "expense",
  "description": "Makan siang di warung",
  "notes": "Warung Mak Soto",
  "transaction_date": "2024-01-20",
  "created_at": "2024-01-20T12:30:00Z",
  "updated_at": "2024-01-20T12:30:00Z"
}
```

### Related Model di Dart
```dart
class TransactionModel {
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final double amount;
  final String transactionType;
  final String? description;
  final String? notes;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionType,
    this.description,
    this.notes,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      accountId: json['account_id'] as String,
      categoryId: json['category_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transaction_type'] as String,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'account_id': accountId,
    'category_id': categoryId,
    'amount': amount,
    'transaction_type': transactionType,
    'description': description,
    'notes': notes,
    'transaction_date': transactionDate.toString().split(' ')[0],
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
```

---

## 5. Budgets Table

**Purpose:** Menyimpan budget/target pengeluaran per kategori

```sql
CREATE TABLE budgets (
  id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  amount numeric NOT NULL,
  period text NOT NULL,
  start_date date NOT NULL,
  end_date date,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `user_id` | UUID | Foreign key ke users |
| `category_id` | UUID | Foreign key ke categories |
| `amount` | numeric | Target budget |
| `period` | text | daily, weekly, monthly, yearly |
| `start_date` | date | Mulai dari kapan |
| `end_date` | date | Berakhir kapan (null = ongoing) |
| `notes` | text | Catatan budget |
| `created_at` | timestamp | Dibuat kapan |
| `updated_at` | timestamp | Diupdate kapan |

### Contoh Data
```json
{
  "id": "950e8400-e29b-41d4-a716-446655440004",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "category_id": "750e8400-e29b-41d4-a716-446655440002",
  "amount": 500000,
  "period": "monthly",
  "start_date": "2024-01-01",
  "end_date": "2024-12-31",
  "notes": "Budget untuk makan",
  "created_at": "2024-01-01T10:30:00Z",
  "updated_at": "2024-01-20T14:45:00Z"
}
```

### Related Model di Dart
```dart
class BudgetModel {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String period;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.period,
    required this.startDate,
    this.endDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      period: json['period'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String)
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'category_id': categoryId,
    'amount': amount,
    'period': period,
    'start_date': startDate.toString().split(' ')[0],
    'end_date': endDate?.toString().split(' ')[0],
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
```

---

## Index Configuration

Untuk optimasi query, create indexes untuk:

```sql
-- Accounts indexes
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_created_at ON accounts(created_at DESC);

-- Categories indexes
CREATE INDEX idx_categories_user_id ON categories(user_id);

-- Transactions indexes
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_category_id ON transactions(category_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date DESC);

-- Budgets indexes
CREATE INDEX idx_budgets_user_id ON budgets(user_id);
CREATE INDEX idx_budgets_category_id ON budgets(category_id);
```

---

## Foreign Key Relationships

```
users (1) ──── (N) accounts
        ├──── (N) categories
        ├──── (N) transactions
        └──── (N) budgets

accounts (1) ──── (N) transactions
categories (1) ──── (N) transactions
             ├──── (N) budgets
```

---

## Default Categories to Insert

Setelah create tables, insert default categories:

```sql
-- Income categories
INSERT INTO categories (user_id, name, category_type, color, icon_name, is_default)
SELECT 
  users.id,
  'Gaji',
  'income',
  '#10B981',
  'wallet',
  true
FROM users;

-- Expense categories
INSERT INTO categories (user_id, name, category_type, color, icon_name, is_default)
SELECT 
  users.id,
  'Makan & Minum',
  'expense',
  '#F59E0B',
  'utensils',
  true
FROM users;

INSERT INTO categories (user_id, name, category_type, color, icon_name, is_default)
SELECT 
  users.id,
  'Transportasi',
  'expense',
  '#3B82F6',
  'car',
  true
FROM users;

-- Transfer category
INSERT INTO categories (user_id, name, category_type, color, icon_name, is_default)
SELECT 
  users.id,
  'Transfer',
  'transfer',
  '#8B5CF6',
  'arrow-right',
  true
FROM users;
```

---

## Notes

- Semua IDs adalah UUID (unique identifier)
- Foreign keys `ON DELETE CASCADE` berarti data child otomatis dihapus jika parent dihapus
- RLS (Row Level Security) memastikan user hanya bisa akses data mereka sendiri
- `created_at` dan `updated_at` auto-update untuk audit trail
- Decimal untuk `amount` lebih akurat daripada float untuk currency

---

## ✅ Schema Design Complete

Sekarang ada clear picture dari:
- Struktur data
- Relasi antar tabel
- Contoh data
- Model Dart yang matching

Siap untuk integration dengan Flutter app! 🚀

