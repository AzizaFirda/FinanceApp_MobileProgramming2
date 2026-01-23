import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';

class CategoryIcon extends StatelessWidget {
  final CategoryModel category;
  final double size;
  final double iconSize;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(category.icon, style: TextStyle(fontSize: iconSize)),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? Colors.blue.withOpacity(0.2)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? Colors.blue
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryGridItem({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Colors.blue.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? Colors.blue
                    : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryListTile extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CategoryListTile({
    super.key,
    required this.category,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(category.icon, style: const TextStyle(fontSize: 24)),
      ),
      title: Text(
        category.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: trailing,
    );
  }
}
