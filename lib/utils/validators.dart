class Validators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'El correo es obligatorio';
    if (!v.contains('@') || !v.contains('.')) return 'Ingresa un correo válido';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? confirmPassword(String? v, String password) {
    if (v != password) return 'Las contraseñas no coinciden';
    return null;
  }

  static String? required(String? v, String fieldName) {
    if (v == null || v.trim().isEmpty) return '$fieldName es obligatorio';
    return null;
  }
}
