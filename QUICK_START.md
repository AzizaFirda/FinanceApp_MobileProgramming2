# ⚡ Quick Start Guide - 5 Minutes

## Untuk yang ingin langsung mulai tanpa detail 👇

---

## 📋 TL;DR - Apa yang sudah disiapkan untuk Anda

✅ **5 SQL Tables** (users, accounts, categories, transactions, budgets)
✅ **5 Repository Classes** (dengan semua CRUD methods)
✅ **7 Documentation Files** (lengkap dengan examples)
✅ **RLS Security Policies** (user data isolation)
✅ **Storage Setup** (untuk foto profiles)

---

## 🚀 Quick Setup (< 1 hour)

### LANGKAH 1: Database Setup (10 min)
```
1. Buka: https://supabase.com/dashboard
2. Pilih project: money_manager
3. Klik: SQL Editor → New query
4. Copy SEMUA SQL dari: SUPABASE_DATABASE_SETUP.md
5. Paste & klik: Run
6. Wait: ✅ Success
```

### LANGKAH 2: Storage Setup (3 min)
```
1. Klik: Storage (sidebar)
2. Klik: + New bucket
3. Nama: profiles
4. Type: Public ✅
5. Klik: Create bucket
```

### LANGKAH 3: Add Repository Files (20 min)
Copy-paste 5 files dari `REPOSITORY_INTEGRATION_GUIDE.md`:

```
lib/data/repositories/
├── user_repository.dart (from section 1)
├── account_repository.dart (from section 2)
├── category_repository.dart (from section 3)
├── transaction_repository.dart (from section 4)
└── budget_repository.dart (from section 5)
```

### LANGKAH 4: Update main.dart (10 min)
Copy init code dari `REPOSITORY_INTEGRATION_GUIDE.md` section 7

### LANGKAH 5: Verify & Test (10 min)
```bash
flutter pub get
flutter analyze
flutter run
```

Test: Register user → Should create profile in DB ✅

---

## 📂 File Quick Reference

| File | What | When Use |
|------|------|----------|
| `SUPABASE_DATABASE_SETUP.md` | SQL script | Copy to Supabase console |
| `SUPABASE_SETUP_STEP_BY_STEP.md` | Detailed steps | Read if stuck |
| `DATA_MODELS_DOCUMENTATION.md` | Schema reference | Understand structure |
| `REPOSITORY_INTEGRATION_GUIDE.md` | Code to copy | Copy-paste repositories |
| `SUPABASE_COMPLETE_CHECKLIST.md` | Track progress | Follow during setup |
| `SUPABASE_API_REFERENCE.md` | API examples | Reference for queries |
| `README_SUPABASE_SETUP.md` | Full summary | Big picture overview |

---

## 🔑 Your Credentials (KEEP SAFE!)

```
URL: https://omnftoowpnvmtbzfrcig.supabase.co
Anon Key: sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq
```

✅ Safe to put in Flutter app code
❌ Never commit service_role key

---

## 🎯 What You Get After Setup

### Authentication ✅
- User register → Auto create profile
- User login → Session management
- User logout → Clear data
- User forget password → Reset email

### Accounts ✅
- Create multiple accounts (BRI, Cash, E-wallet)
- Track balance per account
- Update account info
- Delete account

### Transactions ✅
- Create income/expense/transfer
- Auto update account balance
- Filter by date/type/category
- See transaction history

### Budget ✅
- Set budget per category
- Track spending vs budget
- Get budget alerts

### Photos ✅
- Upload profile photo
- Store in cloud
- Display in app
- Auto sync

### Security ✅
- User data isolation (RLS)
- Encrypted passwords
- JWT auth tokens
- Safe API access

---

## ❓ Common Questions

**Q: Berapa lama setup?**
A: 1-2 jam (tergantung kecepatan coding)

**Q: Berapa cost?**
A: Gratis! Supabase free tier cukup untuk project ini

**Q: Berapa storage?**
A: 1 GB photos (gratis) - cukup untuk ribuan user

**Q: Bisa offline?**
A: Ya, dengan Hive caching (sudah setup)

**Q: Data aman?**
A: Ya, RLS policies + encrypted + HTTPS

**Q: Bisa scale?**
A: Ya, Supabase auto-scale hingga jutaan users

---

## ⚠️ Important Notes

1. **Execute SQL script completely** (jangan stop di tengah)
2. **Verify RLS policies** setelah SQL done
3. **Test authentication flow** sebelum production
4. **Enable backups** di Supabase settings
5. **Monitor usage** untuk cost tracking

---

## 🎬 First Run Test

```dart
// Di mana di test:
// 1. Register user baru
// 2. Check Supabase → Authentication tab
// 3. Verify user ada di users table

// 2. Create account baru
// 4. Check Supabase → Database → accounts table
// 5. Verify account ada dengan user_id = current user

// 3. Upload photo
// 6. Check Supabase → Storage → profiles bucket
// 7. Verify file ada

// 4. Create transaction
// 8. Check Supabase → transactions table
// 9. Verify account balance updated
```

---

## 🆘 If Something Wrong

### Error: "table does not exist"
→ SQL script tidak full dijalankan. Run lagi dari awal.

### Error: "permission denied"
→ Bukan logged in dengan project owner. Login ulang.

### Error: "RLS policy violation"
→ user_id di record ≠ auth.uid(). Check RLS policies di Supabase.

### Error: "bucket not found"
→ profiles bucket tidak ada. Create manually di Storage.

### App tidak bisa connect
→ Check internet. Test ping Google DNS.

**More help:** SUPABASE_COMPLETE_CHECKLIST.md (Troubleshooting section)

---

## 📚 Learning Path

1. ✅ Setup database (10 min)
2. ✅ Add repositories (20 min)
3. ✅ Update providers (15 min)
4. ✅ Test flows (15 min)
5. ✅ Deploy (5 min)

**Total: ~1 hour**

---

## 🎯 Success Checklist

- [ ] SQL script executed ✅
- [ ] 5 tables exist in Supabase
- [ ] profiles bucket created
- [ ] 5 repository files in project
- [ ] main.dart updated
- [ ] Can register new user
- [ ] Can create account
- [ ] Can create transaction
- [ ] Can upload photo
- [ ] No errors in console

---

## 🚀 Next Steps After Setup

1. **Update remaining providers** (category, budget)
2. **Test all CRUD operations**
3. **Add offline support** (Hive caching)
4. **Setup error handling** (toast notifications)
5. **Deploy to production** (Google Play / App Store)

---

## 💡 Pro Tips

- Use SQL Editor to test queries first
- Check network tab to see API calls
- Enable logging untuk debugging
- Backup data regularly
- Test dengan 2 accounts untuk RLS

---

## 📞 Resources

- **Setup Help:** SUPABASE_SETUP_STEP_BY_STEP.md
- **Code Reference:** REPOSITORY_INTEGRATION_GUIDE.md
- **Data Schema:** DATA_MODELS_DOCUMENTATION.md
- **Full Checklist:** SUPABASE_COMPLETE_CHECKLIST.md

---

## ✅ YOU'RE READY!

Everything is prepared. Just follow the 5 steps above and you'll have a working backend in 1 hour. 

Good luck! 🎉

Questions? Check the detailed documentation files.

