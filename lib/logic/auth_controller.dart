import 'package:flutter/foundation.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/auth_repository.dart';
import '../core/exceptions/auth_exception.dart';
import 'auth_state.dart';

/// Controlador de autenticación que gestiona el estado de login/logout.
/// Extiende ChangeNotifier para que la UI pueda escuchar cambios de estado.
/// Sigue el patrón Controller/ViewModel de Clean Architecture.
class AuthController extends ChangeNotifier {
  /// Repositorio de autenticación (inyectado por constructor)
  final AuthRepository _authRepository;

  /// Estado actual de autenticación (privado)
  AuthState _state = const AuthInitial();

  /// Getter público para el estado actual
  AuthState get state => _state;

  /// Constructor que recibe el repositorio como dependencia
  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// Actualiza el estado y notifica a los listeners
  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Autentica un usuario con email y contraseña.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario
  /// - [password]: Contraseña del usuario
  ///
  /// Flujo:
  /// 1. Cambia estado a Loading
  /// 2. Llama al repositorio para autenticar
  /// 3. Si éxito → cambia a Authenticated con el usuario
  /// 4. Si falla → cambia a Error con el mensaje de la excepción
  Future<void> login(String email, String password) async {
    try {
      // 1. Cambiar a estado de carga
      _updateState(const AuthLoading());

      // 2. Llamar al repositorio (puede tardar varios segundos)
      final user = await _authRepository.login(email, password);

      // 3. Si éxito, cambiar a estado autenticado
      _updateState(AuthAuthenticated(user));
    } on AuthException catch (e) {
      // 4. Si hay error de autenticación, cambiar a estado de error
      _updateState(AuthError(e.message, e.code));
    } catch (e) {
      // 5. Capturar cualquier otro error inesperado
      _updateState(AuthError('Error inesperado: ${e.toString()}'));
    }
  }

  /// Cierra la sesión del usuario actual.
  ///
  /// Flujo:
  /// 1. Cambia estado a Loading
  /// 2. Llama al repositorio para cerrar sesión
  /// 3. Si éxito → cambia a Initial
  /// 4. Si falla → cambia a Error
  Future<void> logout() async {
    try {
      // 1. Cambiar a estado de carga
      _updateState(const AuthLoading());

      // 2. Llamar al repositorio para hacer logout
      await _authRepository.logout();

      // 3. Volver al estado inicial
      _updateState(const AuthInitial());
    } on AuthException catch (e) {
      _updateState(AuthError(e.message, e.code));
    } catch (e) {
      _updateState(AuthError('Error al cerrar sesión: ${e.toString()}'));
    }
  }

  /// Verifica si hay una sesión activa al iniciar la app.
  ///
  /// Útil para:
  /// - Verificar sesión al abrir la app
  /// - Implementar "Remember me"
  /// - Navegación automática a Home si ya está autenticado
  Future<void> checkAuthStatus() async {
    try {
      // 1. Verificar si está autenticado
      final isAuthenticated = await _authRepository.isAuthenticated();

      if (!isAuthenticated) {
        // No hay sesión activa
        _updateState(const AuthInitial());
        return;
      }

      // 2. Obtener usuario actual del cache
      final currentUser = await _authRepository.getCurrentUser();

      if (currentUser != null) {
        // Hay sesión activa válida
        _updateState(AuthAuthenticated(currentUser));
      } else {
        // No hay usuario guardado
        _updateState(const AuthInitial());
      }
    } catch (e) {
      // Error al verificar sesión
      _updateState(const AuthInitial());
    }
  }

  /// Limpia el estado de error.
  /// Útil para resetear después de mostrar un mensaje de error.
  void clearError() {
    if (_state is AuthError) {
      _updateState(const AuthInitial());
    }
  }

  /// Marca la sesión como expirada.
  /// La UI debe redirigir al login cuando esto ocurra.
  void markSessionExpired() {
    _updateState(const AuthSessionExpired());
  }

  /// Obtiene el usuario actual si está autenticado.
  /// Retorna null si no hay usuario autenticado.
  UserEntity? get currentUser {
    return _state.userOrNull;
  }

  /// Verifica si el usuario está autenticado.
  bool get isAuthenticated {
    return _state.isAuthenticated;
  }

  /// Verifica si está en estado de carga.
  bool get isLoading {
    return _state.isLoading;
  }

  /// Verifica si hay un error.
  bool get hasError {
    return _state.isError;
  }

  /// Obtiene el mensaje de error si existe.
  String? get errorMessage {
    return _state.errorMessageOrNull;
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
    super.dispose();
  }
}
