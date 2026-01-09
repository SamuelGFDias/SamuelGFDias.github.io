mixin Validator {
  static RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  static RegExp phoneRegex = RegExp(r'[^0-9]');

  bool isValidEmail(String? value) {
    if (value == null && value!.isEmpty) return false;

    return emailRegex.hasMatch(value);
  }

  bool isValidPhone(String? value) {
    if (value == null && value!.isEmpty) return false;

    return phoneRegex.hasMatch(value);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um e-mail';
    }
    if (!isValidEmail(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }
}
