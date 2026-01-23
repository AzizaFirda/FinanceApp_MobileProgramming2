import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/category_provider.dart';
import '../../../data/models/category_model.dart';
import '../../dialogs/add_category_dialog.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        elevation: 0,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final categories = categoryProvider.getAllCategories();

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada kategori',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan kategori baru untuk memulai',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddCategoryDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Kategori'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(context, category, categoryProvider);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category,
    CategoryProvider categoryProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              category.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(category.name),
        trailing: SizedBox(
          width: 50,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _confirmDeleteCategory(context, category, categoryProvider);
            },
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
  }

  void _confirmDeleteCategory(
    BuildContext context,
    CategoryModel category,
    CategoryProvider categoryProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kategori'),
          content: Text(
            'Yakin ingin menghapus "${category.name}"? '
            'Tidak bisa dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await categoryProvider.deleteCategory(category.id);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kategori berhasil dihapus'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menghapus: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
