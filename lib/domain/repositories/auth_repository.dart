import '../entities/user_entity.dart';

/// Contrato (interface) del repositorio de autenticación.
/// Define las operaciones que deben ser implementadas por la capa de datos.
/// Esta clase pertenece a la capa de dominio y NO contiene implementación,
/// solo define el contrato que debe cumplir cualquier fuente de datos.
abstract class AuthRepository {
  /// Autentica un usuario con email y contraseña.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario
  /// - [password]: Contraseña del usuario
  ///
  /// Retorna:
  /// - [Future<UserEntity>]: Usuario autenticado con su información y token
  ///
  /// Lanza:
  /// - Exception si las credenciales son inválidas
  /// - Exception si hay un error de red o del servidor
  /// - Exception si el usuario no existe
  Future<UserEntity> login(String email, String password);

  /// Cierra la sesión del usuario actual.
  ///
  /// Retorna:
  /// - [Future<void>]: Completa cuando la sesión se cierra exitosamente
  ///
  /// Lanza:
  /// - Exception si hay un error al cerrar sesión
  Future<void> logout();

  /// Obtiene el usuario actualmente autenticado desde el almacenamiento local.
  ///
  /// Retorna:
  /// - [Future<UserEntity?>]: Usuario si existe sesión activa, null en caso contrario
  Future<UserEntity?> getCurrentUser();

  /// Verifica si el token de autenticación actual es válido.
  ///
  /// Retorna:
  /// - [Future<bool>]: true si el token es válido, false en caso contrario
  Future<bool> isAuthenticated();
}
