# 📚 Supabase Integration - Quick Reference & Checklist

## 🎯 Complete Setup Workflow

```
Phase 1: Database Setup
  ├── Execute SQL script (SUPABASE_DATABASE_SETUP.md)
  ├── Verify 5 tables created
  └── Confirm RLS policies active

Phase 2: Storage Setup
  ├── Create 'profiles' bucket
  ├── Set as Public
  └── Configure access

Phase 3: Code Integration
  ├── Create repository files
  ├── Update provider files
  ├── Update main.dart
  └── Test connections

Phase 4: Testing & Deployment
  ├── Test CRUD operations
  ├── Verify data persistence
  ├── Test offline functionality
  └── Deploy to production
```

---

## 📋 Step-by-Step Execution Checklist

### PHASE 1: DATABASE SETUP

#### Step 1.1: Open Supabase Console
- [ ] Open: https://supabase.com/dashboard
- [ ] Login to account
- [ ] Select project: "money_manager"
- [ ] Project URL: https://omnftoowpnvmtbzfrcig.supabase.co

#### Step 1.2: Execute SQL Script
- [ ] Open: SQL Editor (left sidebar)
- [ ] Click: "+ New query"
- [ ] Open file: `SUPABASE_DATABASE_SETUP.md`
- [ ] Copy: Entire SQL script (section "SQL Script - Complete Database Setup")
- [ ] Paste: Into SQL Editor
- [ ] Click: "Run" button
- [ ] Verify: Green checkmark (Success)

#### Step 1.3: Verify Tables Created
- [ ] Open: Database → Tables (left sidebar)
- [ ] Confirm exists:
  - [ ] `users` table
  - [ ] `accounts` table
  - [ ] `categories` table
  - [ ] `transactions` table
  - [ ] `budgets` table
- [ ] Each table has correct columns (check against DATA_MODELS_DOCUMENTATION.md)

#### Step 1.4: Verify RLS Policies
- [ ] Click: `users` table
- [ ] Scroll: To "RLS Policies" section
- [ ] Confirm policies exist:
  - [ ] Users can view own profile
  - [ ] Users can update own profile
  - [ ] Users can insert own profile
  - [ ] Service role can read all
- [ ] Repeat for: accounts, categories, transactions, budgets tables

#### Step 1.5: Verify Indexes Created
- [ ] Click: Each table
- [ ] Scroll: To "Indexes" section
- [ ] Confirm indexes for:
  - [ ] user_id
  - [ ] created_at (for ordering)
  - [ ] Foreign keys

---

### PHASE 2: STORAGE SETUP

#### Step 2.1: Create Storage Bucket
- [ ] Open: Storage (left sidebar)
- [ ] Click: "+ New bucket"
- [ ] Fill form:
  - [ ] Bucket name: `profiles` (lowercase, no spaces)
  - [ ] Public bucket: ✅ (checked)
- [ ] Click: "Create bucket"

#### Step 2.2: Verify Bucket
- [ ] Confirm in Buckets list: `profiles` bucket exists
- [ ] Type: Public
- [ ] Created date: Today

#### Step 2.3: Setup Bucket Policies (Optional - Auto)
- [ ] Click: `profiles` bucket
- [ ] Tab: "Policies"
- [ ] Confirm auto-policies created:
  - [ ] Public read access
  - [ ] Authenticated write access (own folder)

---

### PHASE 3: CODE INTEGRATION

#### Step 3.1: Create Repository Files
- [ ] File: `lib/data/repositories/user_repository.dart`
  - [ ] Copy code from: REPOSITORY_INTEGRATION_GUIDE.md (Section 1)
  - [ ] Paste & save
  - [ ] Run: `flutter pub get`

- [ ] File: `lib/data/repositories/account_repository.dart`
  - [ ] Copy code from: REPOSITORY_INTEGRATION_GUIDE.md (Section 2)
  - [ ] Paste & save

- [ ] File: `lib/data/repositories/category_repository.dart`
  - [ ] Copy code from: REPOSITORY_INTEGRATION_GUIDE.md (Section 3)
  - [ ] Paste & save

- [ ] File: `lib/data/repositories/transaction_repository.dart`
  - [ ] Copy code from: REPOSITORY_INTEGRATION_GUIDE.md (Section 4)
  - [ ] Paste & save

- [ ] File: `lib/data/repositories/budget_repository.dart`
  - [ ] Copy code from: REPOSITORY_INTEGRATION_GUIDE.md (Section 5)
  - [ ] Paste & save

#### Step 3.2: Update main.dart
- [ ] Open: `lib/main.dart`
- [ ] Reference: REPOSITORY_INTEGRATION_GUIDE.md (Section 7)
- [ ] Update: Repository initialization
- [ ] Update: Provider setup with repositories
- [ ] Verify: No errors

#### Step 3.3: Update Provider Files
- [ ] File: `lib/providers/auth_provider.dart`
  - [ ] Add: UserRepository injection
  - [ ] Update: Register method to create user profile
  
- [ ] File: `lib/providers/account_provider.dart`
  - [ ] Update: All methods to use AccountRepository
  
- [ ] File: `lib/providers/category_provider.dart`
  - [ ] Update: All methods to use CategoryRepository
  
- [ ] File: `lib/providers/transaction_provider.dart`
  - [ ] Update: All methods to use TransactionRepository
  - [ ] Add: Account balance update logic
  
- [ ] File: `lib/providers/budget_provider.dart`
  - [ ] Update: All methods to use BudgetRepository

#### Step 3.4: Format & Verify Code
- [ ] Run: `flutter format .` (format all files)
- [ ] Run: `flutter analyze` (check for errors)
- [ ] Fix: Any compilation errors
- [ ] Run: `flutter pub get` (ensure all dependencies)

---

### PHASE 4: TESTING

#### Step 4.1: Test Authentication
- [ ] Create new user via app registration
- [ ] Verify: User created in Supabase Auth
- [ ] Verify: User profile created in `users` table
- [ ] Test: Login with created user
- [ ] Test: Logout functionality
- [ ] Test: Password reset

#### Step 4.2: Test Account Management
- [ ] Create account via app
- [ ] Verify: Account in Supabase `accounts` table
- [ ] Verify: Data matches input
- [ ] Update: Account details
- [ ] Verify: Changes in Supabase
- [ ] Delete: Account
- [ ] Verify: Deleted from Supabase

#### Step 4.3: Test Category Management
- [ ] Create category via app
- [ ] Verify: Category in `categories` table
- [ ] Update: Category (name, color, icon)
- [ ] Verify: Changes in Supabase
- [ ] Delete: Category
- [ ] Verify: Deleted from Supabase
- [ ] Note: Check RLS - should only see own categories

#### Step 4.4: Test Transactions
- [ ] Create transaction
- [ ] Verify: In `transactions` table
- [ ] Verify: Account balance updated
- [ ] Check: Amount deducted from account
- [ ] Update: Transaction amount
- [ ] Verify: Balance recalculated correctly
- [ ] Delete: Transaction
- [ ] Verify: Balance restored

#### Step 4.5: Test Budgets
- [ ] Create budget for category
- [ ] Verify: In `budgets` table
- [ ] Check: Can query budget by category
- [ ] Test: Budget exceeded check
- [ ] Update: Budget amount
- [ ] Delete: Budget

#### Step 4.6: Test Storage (Photos)
- [ ] In settings, upload profile photo
- [ ] Verify: File in Supabase Storage > profiles
- [ ] Verify: Photo displays in app
- [ ] Update: Photo (upload new one)
- [ ] Delete: Photo
- [ ] Verify: Removed from storage

#### Step 4.7: Test Offline Functionality
- [ ] Enable Airplane Mode
- [ ] Try: Add transaction
- [ ] Verify: Uses local cache (Hive)
- [ ] Disable Airplane Mode
- [ ] Verify: Data syncs to Supabase

#### Step 4.8: Test Cross-User Isolation (RLS)
- [ ] Create 2 test accounts
- [ ] User A: Create transaction, account, category
- [ ] Switch to User B
- [ ] Verify: Cannot see User A's data
- [ ] Verify: RLS policies working correctly

---

## 🔗 File References

### Setup & Configuration Files

| File | Purpose | Status |
|------|---------|--------|
| `SUPABASE_DATABASE_SETUP.md` | SQL schema & setup | ✅ Created |
| `SUPABASE_SETUP_STEP_BY_STEP.md` | Detailed setup guide | ✅ Created |
| `DATA_MODELS_DOCUMENTATION.md` | Data models & schemas | ✅ Created |
| `REPOSITORY_INTEGRATION_GUIDE.md` | Repository code | ✅ Created |

### Code Files to Modify

| File | Update | Priority |
|------|--------|----------|
| `lib/main.dart` | Initialize repositories | HIGH |
| `lib/providers/auth_provider.dart` | UserRepository integration | HIGH |
| `lib/providers/account_provider.dart` | AccountRepository integration | HIGH |
| `lib/providers/category_provider.dart` | CategoryRepository integration | MEDIUM |
| `lib/providers/transaction_provider.dart` | TransactionRepository integration | MEDIUM |
| `lib/providers/budget_provider.dart` | BudgetRepository integration | MEDIUM |
| `lib/data/repositories/*.dart` | Create new repository files | HIGH |

---

## 🔐 Security Checklist

- [ ] **Never commit service_role key** to git
- [ ] **Use anon key only** in Flutter app code
  - [ ] Anon Key: `sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq`
- [ ] **Verify RLS policies** prevent cross-user access
- [ ] **Test user isolation** with multiple accounts
- [ ] **Setup Row Security:**
  - [ ] Users can only see own data
  - [ ] Users can only modify own data
  - [ ] Service role (admin) can access all
- [ ] **Secure Storage:**
  - [ ] profiles bucket set to Public (for images)
  - [ ] All other buckets Private
- [ ] **Database Backups:**
  - [ ] Enable auto-backups in Supabase settings
  - [ ] Test backup restore

---

## 📊 Key Supabase Credentials

```
Project Name: money_manager
URL: https://omnftoowpnvmtbzfrcig.supabase.co
Anon Key: sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq

Tables: users, accounts, categories, transactions, budgets
Storage Bucket: profiles
```

**KEEP THESE SAFE! Add to .env file in production.**

---

## 🐛 Troubleshooting Quick Guide

### Database Issues

**Problem:** "relation does not exist"
```
Solution: 
1. Check table name spelling
2. Run SQL script again
3. Verify in Database → Tables
```

**Problem:** "permission denied for schema public"
```
Solution:
1. Log in with project owner account
2. Check user role in project settings
3. Recreate project if necessary
```

**Problem:** "new row violates row-level security policy"
```
Solution:
1. Verify user_id matches current user
2. Check RLS policies are enabled
3. Ensure auth.uid() returns correct value
```

### Authentication Issues

**Problem:** User can see other users' data
```
Solution:
1. Check RLS policies
2. Verify user_id = auth.uid() in queries
3. Test with test-browser in Supabase
```

**Problem:** "Invalid login credentials"
```
Solution:
1. Verify email is correct
2. Check password is correct
3. Ensure user exists in Auth tab
4. Test in Supabase console first
```

### Storage Issues

**Problem:** Cannot upload photos
```
Solution:
1. Check 'profiles' bucket exists
2. Verify bucket is Public
3. Check user has write permission
4. Check file size < 10MB
```

**Problem:** Photo URL not accessible
```
Solution:
1. Verify bucket is Public
2. Check file exists in bucket
3. Use correct public URL format:
   https://omnftoowpnvmtbzfrcig.supabase.co/storage/v1/object/public/profiles/{filename}
```

### Network Issues

**Problem:** "Network error" when querying
```
Solution:
1. Check internet connection
2. Verify Supabase status (status.supabase.com)
3. Check firewall/VPN blocking
4. Test in different network
```

**Problem:** Timeout on large queries
```
Solution:
1. Add pagination with .range(0, 50)
2. Filter data before querying
3. Use indexes on frequently queried columns
4. Check database performance in Analytics
```

---

## 📞 Support Resources

### Documentation
- Supabase Docs: https://supabase.com/docs
- REST API: https://supabase.com/docs/guides/api
- RLS Guide: https://supabase.com/docs/guides/auth/row-level-security
- Storage: https://supabase.com/docs/guides/storage

### Debugging Tools
- **Supabase Console Logs:** Project Settings → Logs
- **SQL Editor:** Test queries directly
- **Network Tab:** Check API requests
- **Flutter DevTools:** Check local state
- **Logcat (Android):** Check native logs

### Community Help
- Supabase Discord: https://discord.supabase.io
- Stack Overflow: tag `supabase`
- GitHub Issues: supabase/supabase

---

## 🚀 Deployment Checklist

### Pre-Production
- [ ] All tests passing
- [ ] No console errors/warnings
- [ ] RLS policies verified secure
- [ ] Database backups enabled
- [ ] Credentials in .env, not in code
- [ ] API keys rotated
- [ ] Error handling comprehensive
- [ ] Logging configured

### Production Deployment
- [ ] Use production Supabase project
- [ ] Update .env with prod credentials
- [ ] Test in staging first
- [ ] Monitor logs during rollout
- [ ] Have rollback plan ready
- [ ] Document any schema changes
- [ ] Notify users of maintenance

---

## ✅ Final Verification

Run this checklist before considering setup complete:

```
Database Setup:
  ✅ SQL script executed
  ✅ 5 tables created and verified
  ✅ RLS policies active
  ✅ Indexes created
  ✅ Default categories inserted

Storage Setup:
  ✅ profiles bucket created
  ✅ Bucket set to Public
  ✅ Policies configured

Code Integration:
  ✅ 5 repository files created
  ✅ main.dart updated
  ✅ All providers updated
  ✅ No compilation errors
  ✅ All imports correct

Testing:
  ✅ User registration works
  ✅ User login works
  ✅ Create account works
  ✅ Create transaction works
  ✅ Photo upload works
  ✅ RLS isolation verified
  ✅ Offline caching works

Security:
  ✅ Service key not in code
  ✅ RLS policies verified
  ✅ User isolation confirmed
  ✅ Credentials in .env
  ✅ Backups enabled
```

---

## 🎉 Success!

Sekarang Money Manager app Anda fully powered by Supabase! 

Data Anda:
- 🔒 Aman dengan RLS policies
- ☁️ Tersimpan di cloud (PostgreSQL)
- 📱 Sync across devices
- 🔄 Real-time updates
- 📸 Foto tersimpan dengan aman

Happy coding! 🚀

