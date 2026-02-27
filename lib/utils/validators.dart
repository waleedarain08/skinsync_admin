abstract final class Validators {
  static String? empty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This value is required.';
    }
    return null;
  }

  /// Email Validator
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter';
    // }

    // if (!RegExp(r'[a-z]').hasMatch(value)) {
    //   return 'Password must contain at least one lowercase letter';
    // }

    // if (!RegExp(r'\d').hasMatch(value)) {
    //   return 'Password must contain at least one number';
    // }

    // if (!RegExp(r'[!@#\$&*~%^()_\-+=<>?]').hasMatch(value)) {
    //   return 'Password must contain at least one special character';
    // }

    return null;
  }

  static String? phone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone is required';
    }
    final regExp = RegExp(r'^\+?[1-9]\d{6,14}$');
    if (!regExp.hasMatch(phone)) {
      return 'Invalid Phone';
    }
    return null;
  }
}
