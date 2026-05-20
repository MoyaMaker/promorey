import 'package:firebase_auth/firebase_auth.dart';

String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'INVALID_LOGIN_CREDENTIALS':
      return 'Correo electrónico o contraseña incorrectos';
    case 'user-not-found':
    case 'USER_NOT_FOUND':
      return 'No se encontró una cuenta con este correo';
    case 'wrong-password':
    case 'WRONG_PASSWORD':
      return 'Contraseña incorrecta';
    case 'email-already-in-use':
    case 'EMAIL_ALREADY_IN_USE':
      return 'Este correo ya está registrado';
    case 'weak-password':
    case 'WEAK_PASSWORD':
      return 'La contraseña debe tener al menos 6 caracteres';
    case 'invalid-email':
    case 'INVALID_EMAIL':
      return 'El formato del correo no es válido';
    case 'too-many-requests':
    case 'TOO_MANY_REQUESTS':
      return 'Demasiados intentos. Intenta de nuevo más tarde';
    case 'network-request-failed':
    case 'NETWORK_REQUEST_FAILED':
      return 'Error de conexión. Verifica tu internet';
    case 'operation-not-allowed':
    case 'OPERATION_NOT_ALLOWED':
      return 'Esta operación no está habilitada';
    case 'user-disabled':
    case 'USER_DISABLED':
      return 'Esta cuenta ha sido deshabilitada';
    default:
      return 'Ocurrió un error. Intenta de nuevo';
  }
}
