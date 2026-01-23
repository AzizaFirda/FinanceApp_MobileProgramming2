import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? AppColors.textPrimary,
        ),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      elevation: elevation,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight = 200,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? AppColors.textPrimary,
        ),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      elevation: 0,
    );
  }
}
