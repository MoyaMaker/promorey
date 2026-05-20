import 'package:firebase_core/firebase_core.dart';

String getFirestoreErrorMessage(dynamic e) {
  if (e is FirebaseException) {
    switch (e.code) {
      case 'permission-denied':
        return 'No tienes permiso para realizar esta acción';
      case 'unavailable':
        return 'Servicio temporalmente no disponible';
      case 'not-found':
        return 'La promoción no se encontró';
      case 'already-exists':
        return 'El registro ya existe';
      case 'cancelled':
        return 'La operación fue cancelada';
      case 'deadline-exceeded':
        return 'La operación tardó demasiado. Intenta de nuevo';
      case 'internal':
        return 'Error interno del servidor. Intenta de nuevo';
      case 'invalid-argument':
        return 'Los datos proporcionados no son válidos';
      case 'unauthenticated':
        return 'Debes iniciar sesión para realizar esta acción';
      case 'failed-precondition':
        return 'La operación no pudo completarse. Intenta de nuevo';
      default:
        return 'Ocurrió un error inesperado. Intenta de nuevo';
    }
  }
  return 'Ocurrió un error inesperado. Intenta de nuevo';
}
