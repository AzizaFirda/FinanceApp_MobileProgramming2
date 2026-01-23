import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  // Responsive
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  // Orientation
  Orientation get orientation => mediaQuery.orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // Brightness
  Brightness get brightness => theme.brightness;
  bool get isDarkMode => brightness == Brightness.dark;
  bool get isLightMode => brightness == Brightness.light;

  // Navigation
  NavigatorState get navigator => Navigator.of(this);

  void pop<T>([T? result]) => navigator.pop(result);

  Future<T?> push<T>(Widget page) {
    return navigator.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacement<T, TO>(Widget page, {TO? result}) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  Future<T?> pushAndRemoveUntil<T>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    navigator.popUntil(predicate);
  }

  // Snackbar
  void showSnackBar(
    String message, {
    Duration? duration,
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  void showWarningSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.orange);
  }

  void showInfoSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.blue);
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  // Dialog
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }

  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showAppDialog<bool>(
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => pop(false), child: Text(cancelText)),
          ElevatedButton(onPressed: () => pop(true), child: Text(confirmText)),
        ],
      ),
    );
  }

  // Bottom Sheet
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }

  // Focus
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }

  // Scaffold
  ScaffoldState get scaffold => Scaffold.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  // Form
  FormState? get form => Form.maybeOf(this);

  bool validateForm() {
    final formState = form;
    if (formState == null) return false;
    return formState.validate();
  }

  void resetForm() {
    form?.reset();
  }

  void saveForm() {
    form?.save();
  }
}
