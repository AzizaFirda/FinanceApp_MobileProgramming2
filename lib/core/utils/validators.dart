import '../constants/app_constants.dart';

class Validators {
  // Required field validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!AppConstants.emailPattern.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Phone validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!AppConstants.phonePattern.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Amount validator
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    if (value.length > AppConstants.maxAmountLength) {
      return 'Amount is too large';
    }
    return null;
  }

  // Number validator
  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!AppConstants.numberPattern.hasMatch(value)) {
      return 'Please enter numbers only';
    }
    return null;
  }

  // Positive number validator
  static String? positiveNumber(String? value) {
    final numberError = number(value);
    if (numberError != null) return numberError;

    final num = int.tryParse(value!);
    if (num == null || num <= 0) {
      return 'Please enter a positive number';
    }
    return null;
  }

  // Min length validator
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  // Max length validator
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null) return null;
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} cannot exceed $maxLength characters';
    }
    return null;
  }

  // Range validator (for numbers)
  static String? range(String? value, double min, double max) {
    final number = double.tryParse(value ?? '');
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < min || number > max) {
      return 'Value must be between $min and $max';
    }
    return null;
  }

  // Date validator
  static String? date(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    return null;
  }

  // Future date validator
  static String? futureDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    if (value.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }
    return null;
  }

  // Past date validator
  static String? pastDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    if (value.isAfter(DateTime.now())) {
      return 'Date must be in the past';
    }
    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Confirm password validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Username validator
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 20) {
      return 'Username cannot exceed 20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // URL validator
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlPattern.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  // Category name validator
  static String? categoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category name is required';
    }
    if (value.trim().length < 2) {
      return 'Category name must be at least 2 characters';
    }
    if (value.length > AppConstants.maxCategoryNameLength) {
      return 'Category name is too long';
    }
    return null;
  }

  // Account name validator
  static String? accountName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account name is required';
    }
    if (value.trim().length < 2) {
      return 'Account name must be at least 2 characters';
    }
    if (value.length > AppConstants.maxAccountNameLength) {
      return 'Account name is too long';
    }
    return null;
  }

  // Note validator (optional but with max length)
  static String? note(String? value) {
    if (value != null && value.length > AppConstants.maxNoteLength) {
      return 'Note is too long (max ${AppConstants.maxNoteLength} characters)';
    }
    return null;
  }

  // Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
