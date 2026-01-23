import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../data/models/category_model.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _nameController;
  late String _selectedIcon;
  bool _isLoading = false;

  // All category icons
  final List<String> _allIcons = [
    '🍔', // Food
    '🚗', // Transportation
    '🛒', // Shopping
    '🏠', // Housing
    '📱', // Bills
    '🏥', // Health
    '✈️', // Travel
    '🎬', // Entertainment
    '🎓', // Education
    '💄', // Personal Care
    '🏋️', // Fitness
    '🎁', // Gifts
    '💰', // Salary
    '🎁', // Bonus
    '💼', // Freelance
    '📈', // Investment
    '🏪', // Business
    '👨‍💼', // Part-time
    '🤝', // Commission
    '🎓', // Scholarship
    '🏆', // Award
    '💵', // Gift Money
    '💎', // Crypto
    '📊', // Dividend
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedIcon = _allIcons[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Kategori Baru',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Masukkan nama kategori',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pilih Icon:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _allIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _allIcons[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedIcon == icon ? Colors.blue : Colors.grey,
                            width: _selectedIcon == icon ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: _selectedIcon == icon
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createCategory,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Buat'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final category = CategoryModel.create(
        name: _nameController.text.trim(),
        icon: _selectedIcon,
      );

      if (!mounted) return;

      final success = await Provider.of<CategoryProvider>(context, listen: false)
          .addCategory(category);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, category);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Kategori berhasil dibuat'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Gagal membuat kategori'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}