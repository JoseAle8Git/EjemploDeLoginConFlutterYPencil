import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/exceptions/auth_exception.dart';
import '../models/user_model.dart';

/// Implementación concreta del repositorio de autenticación.
/// Esta clase pertenece a la capa de datos y contiene la lógica de implementación.
/// Por ahora simula datos de prueba, pero está preparada para integrar datasources reales.
class AuthRepositoryImpl implements AuthRepository {
  // TODO: Inyectar dependencias cuando estén disponibles
  // final AuthRemoteDataSource remoteDataSource;
  // final AuthLocalDataSource localDataSource;

  /// Usuario actualmente autenticado (simulado en memoria)
  UserModel? _currentUser;

  /// Constructor
  /// En el futuro recibirá datasources como dependencias:
  /// AuthRepositoryImpl({
  ///   required this.remoteDataSource,
  ///   required this.localDataSource,
  /// });
  AuthRepositoryImpl();

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      // Simular delay de red (2 segundos)
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Reemplazar con llamada real al datasource
      // final userModel = await remoteDataSource.login(email, password);

      // Validar credenciales de prueba
      if (email == 'test@green.com' && password == '123456') {
        // Crear usuario de prueba con datos simulados
        final userModel = UserModel(
          id: 'user_123',
          email: email,
          name: 'Usuario de Prueba',
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        );

        // Guardar usuario en memoria (simula cache local)
        _currentUser = userModel;

        // TODO: Guardar en almacenamiento local persistente
        // await localDataSource.saveUser(userModel);

        return userModel;
      } else {
        // Credenciales inválidas
        throw AuthException.invalidCredentials();
      }
    } on AuthException {
      // Re-lanzar excepciones de autenticación sin modificar
      rethrow;
    } catch (e) {
      // Capturar cualquier otro error y convertirlo en AuthException
      throw AuthException.serverError(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Simular delay de operación
      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: Llamar al servidor para invalidar el token
      // await remoteDataSource.logout();

      // Limpiar usuario actual
      _currentUser = null;

      // TODO: Limpiar almacenamiento local
      // await localDataSource.clearUser();
    } catch (e) {
      throw AuthException.serverError(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Simular delay de lectura
      await Future.delayed(const Duration(milliseconds: 200));

      // TODO: Leer desde almacenamiento local persistente
      // final userModel = await localDataSource.getUser();

      // Por ahora retornar el usuario en memoria
      return _currentUser;
    } catch (e) {
      // Si hay error al obtener usuario, retornar null
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Obtener usuario actual
      final user = await getCurrentUser();

      // Si no hay usuario, no está autenticado
      if (user == null) {
        return false;
      }

      // TODO: Validar token con el servidor
      // final isValid = await remoteDataSource.validateToken(user.token);

      // Por ahora simular validación básica
      // En producción, aquí se validaría el token JWT con el servidor
      return user.token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
