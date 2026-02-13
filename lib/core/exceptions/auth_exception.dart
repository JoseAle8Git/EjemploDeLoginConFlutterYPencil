/// Excepción personalizada para errores relacionados con autenticación.
/// Esta clase permite manejar errores específicos de la capa de datos.
class AuthException implements Exception {
  /// Mensaje descriptivo del error
  final String message;

  /// Código de error opcional (para categorizar tipos de error)
  final String? code;

  /// Detalles adicionales del error
  final dynamic details;

  const AuthException({
    required this.message,
    this.code,
    this.details,
  });

  /// Constructor para credenciales inválidas
  factory AuthException.invalidCredentials() {
    return const AuthException(
      message: 'Email o contraseña incorrectos',
      code: 'INVALID_CREDENTIALS',
    );
  }

  /// Constructor para usuario no encontrado
  factory AuthException.userNotFound() {
    return const AuthException(
      message: 'Usuario no encontrado',
      code: 'USER_NOT_FOUND',
    );
  }

  /// Constructor para error de red
  factory AuthException.networkError() {
    return const AuthException(
      message: 'Error de conexión. Verifica tu internet',
      code: 'NETWORK_ERROR',
    );
  }

  /// Constructor para error del servidor
  factory AuthException.serverError([String? details]) {
    return AuthException(
      message: 'Error del servidor. Intenta más tarde',
      code: 'SERVER_ERROR',
      details: details,
    );
  }

  /// Constructor para sesión expirada
  factory AuthException.sessionExpired() {
    return const AuthException(
      message: 'Sesión expirada. Vuelve a iniciar sesión',
      code: 'SESSION_EXPIRED',
    );
  }

  /// Constructor para token inválido
  factory AuthException.invalidToken() {
    return const AuthException(
      message: 'Token de autenticación inválido',
      code: 'INVALID_TOKEN',
    );
  }

  @override
  String toString() {
    return 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
