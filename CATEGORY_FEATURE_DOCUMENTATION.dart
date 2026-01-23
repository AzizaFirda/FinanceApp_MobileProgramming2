// CATEGORY CREATION FEATURE DOCUMENTATION
// =========================================

/*
DATABASE SCHEMA ALIGNMENT
=========================

Supabase Categories Table Schema:
```sql
CREATE TABLE public.categories (
  id text NOT NULL,                              ✅ TEXT (UUID v4)
  user_id uuid NOT NULL,                         ✅ UUID (from Supabase auth)
  name text NOT NULL,                            ✅ TEXT (user input)
  type text NOT NULL,                            ✅ TEXT ('expense' or 'income')
  icon text NOT NULL,                            ✅ TEXT (emoji string)
  color integer NOT NULL DEFAULT -1049552127,   ✅ INTEGER (Color value)
  is_default boolean DEFAULT false,              ✅ BOOLEAN (false for custom)
  created_at timestamp with time zone,           ✅ DATETIME (DateTime.now())
  updated_at timestamp with time zone,           ✅ DATETIME (DateTime.now())
  ...
);
```

FEATURE IMPLEMENTATION
======================

1. ADD CATEGORY DIALOG
   File: lib/presentation/dialogs/add_category_dialog.dart
   
   Features:
   - Separate icon sets for Income & Expense categories
   - Color picker (8 color options)
   - Name input field with validation
   - Loading state during creation
   - Error handling with user feedback
   
   Data Flow:
   Input → Validation → CategoryModel → Provider → Repository → Supabase

2. CATEGORY MODEL
   File: lib/data/models/category_model.dart
   
   Fields mapped to database:
   - id: UUID v4 (generated via Uuid package)
   - name: String (trimmed user input)
   - type: CategoryType enum (converted to 'expense'/'income' string)
   - icon: String (selected emoji)
   - color: int (Color.value from selected color)
   - isDefault: bool (always false for custom categories)
   - createdAt: DateTime (current time)
   - updatedAt: DateTime (current time)

3. CATEGORY REPOSITORY
   File: lib/data/repositories/category_repository.dart
   
   Method: createCategorySupabase(CategoryModel category)
   
   Process:
   1. Check authentication
   2. Prepare data map with all required fields
   3. Insert into Supabase 'categories' table
   4. Store locally in Hive
   5. Log success/error with detailed messages
   
   Data being sent to Supabase:
   {
     'id': String (UUID),
     'user_id': UUID (from Supabase auth),
     'name': String,
     'type': 'expense' | 'income',
     'icon': String (emoji),
     'color': int,
     'is_default': false
   }

4. CATEGORY PROVIDER
   File: lib/providers/category_provider.dart
   
   Method: addCategory(CategoryModel category)
   - Calls repository.createCategorySupabase()
   - Reloads all categories
   - Updates listeners
   - Returns success status

ICON CONFIGURATION
==================

Expense Categories (12 icons):
  👛 Wallet      💵 Cash         🏦 Mobile Banking  💳 Credit Card
  📱 E-Wallet    🛒 Shopping     🍔 Food            🏥 Health
  ✈️  Travel      🎬 Entertainment  🏠 House        ⚡ Utilities

Income Categories (12 icons):
  💰 Salary      🎁 Bonus        💵 Cash            💸 Money
  📈 Investment  🏪 Business     👨‍💼 Work           🤝 Freelance
  🎓 Scholarship  🏆 Award       💎 Premium        🌟 Opportunity

COLOR PALETTE
=============

8 predefined colors available:
  🔴 Red (#EF4444)      🟠 Orange (#F97316)   🟡 Yellow (#EAB308)
  🟢 Green (#22C55E)    🔵 Cyan (#06B6D4)     🔷 Blue (#3B82F6)
  🟣 Purple (#8B5CF6)   🟥 Pink (#EC4899)

COLOR STORAGE
=============

- Flutter Color → Color.value (integer)
- Stored in Supabase as integer
- Example: Color(0xFFEF4444).value = -1140850945

ERROR HANDLING
==============

1. Validation:
   - Empty name validation
   - Required fields check
   
2. Authentication:
   - User must be logged in
   - User ID from Supabase auth
   
3. Network:
   - Try-catch blocks around Supabase calls
   - Fallback to local storage (Hive)
   - User-friendly error messages
   
4. User Feedback:
   - Success: Green SnackBar with checkmark
   - Error: Red SnackBar with error message
   - Loading: Spinner during creation

DEBUG LOGGING
=============

Console output shows:
  🎯 Creating category: [name]
  📤 Sending to Supabase: [data object]
  🟢 Category synced to Supabase: [name]
  ❌ Error creating category in Supabase: [error message]

TESTING CHECKLIST
=================

✅ Category name validation (empty check)
✅ Icon selection required
✅ Color selection changes
✅ Separate icons for income/expense
✅ Data sent to Supabase matches schema
✅ Local storage updated
✅ User feedback on success
✅ Error handling on failure
✅ Category list updated after creation
✅ UUID generation unique
✅ User_id correctly retrieved from auth
✅ Type correctly converted to string
✅ is_default always false for custom
✅ Timestamps created correctly

INTEGRATION POINTS
==================

1. Transaction Screen:
   - Show all categories with delete option
   - Add new category button
   - Select category for transaction

2. Category Management Screen:
   - View all categories by type
   - Add new categories
   - Delete custom categories

3. Database Sync:
   - Create locally (Hive)
   - Sync to Supabase
   - Load on app start
   - RLS enforces user_id = auth.uid()
*/

// EXAMPLE USAGE
// =============
//
// 1. Create new category via dialog:
//    ```dart
//    final newCategory = await showDialog(
//      context: context,
//      builder: (context) => AddCategoryDialog(
//        type: CategoryType.expense,
//      ),
//    );
//    ```
//
// 2. Manual creation in code:
//    ```dart
//    final category = CategoryModel(
//      id: const Uuid().v4(),
//      name: 'Groceries',
//      type: CategoryType.expense,
//      icon: '🛒',
//      color: Colors.green.value,
//      isDefault: false,
//      createdAt: DateTime.now(),
//      updatedAt: DateTime.now(),
//    );
//    
//    await Provider.of<CategoryProvider>(context, listen: false)
//        .addCategory(category);
//    ```
