import 'package:flutter/foundation.dart';
import '../domain/entities/user_entity.dart';

/// Clase abstracta que representa el estado de autenticación.
/// Usa el patrón State para manejar diferentes estados de la UI.
@immutable
abstract class AuthState {
  const AuthState();
}

/// Estado inicial - La aplicación acaba de iniciar.
/// No hay intento de autenticación en curso.
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthInitial;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'AuthInitial()';
}

/// Estado de carga - Se está procesando una autenticación.
/// La UI debe mostrar un indicador de progreso.
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthLoading;

  @override
  int get hashCode => 1;

  @override
  String toString() => 'AuthLoading()';
}

/// Estado autenticado - El usuario ha iniciado sesión exitosamente.
/// Contiene la información del usuario autenticado.
class AuthAuthenticated extends AuthState {
  /// Usuario autenticado con su información y token
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthAuthenticated && other.user == user);

  @override
  int get hashCode => user.hashCode;

  @override
  String toString() => 'AuthAuthenticated(user: ${user.email})';
}

/// Estado de error - Ocurrió un error durante la autenticación.
/// Contiene el mensaje de error para mostrar al usuario.
class AuthError extends AuthState {
  /// Mensaje de error descriptivo
  final String message;

  /// Código de error opcional (para categorización)
  final String? code;

  const AuthError(this.message, [this.code]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthError &&
          other.message == message &&
          other.code == code);

  @override
  int get hashCode => message.hashCode ^ (code?.hashCode ?? 0);

  @override
  String toString() =>
      'AuthError(message: $message${code != null ? ', code: $code' : ''})';
}

/// Estado de sesión expirada - El token ha expirado.
/// La UI debe redirigir al login.
class AuthSessionExpired extends AuthState {
  const AuthSessionExpired();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthSessionExpired;

  @override
  int get hashCode => 2;

  @override
  String toString() => 'AuthSessionExpired()';
}

/// Extensión para facilitar la verificación de estados
extension AuthStateExtension on AuthState {
  /// Retorna true si el estado es Initial
  bool get isInitial => this is AuthInitial;

  /// Retorna true si el estado es Loading
  bool get isLoading => this is AuthLoading;

  /// Retorna true si el estado es Authenticated
  bool get isAuthenticated => this is AuthAuthenticated;

  /// Retorna true si el estado es Error
  bool get isError => this is AuthError;

  /// Retorna true si el estado es SessionExpired
  bool get isSessionExpired => this is AuthSessionExpired;

  /// Obtiene el usuario si el estado es Authenticated, null en caso contrario
  UserEntity? get userOrNull {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).user;
    }
    return null;
  }

  /// Obtiene el mensaje de error si el estado es Error, null en caso contrario
  String? get errorMessageOrNull {
    if (this is AuthError) {
      return (this as AuthError).message;
    }
    return null;
  }
}
