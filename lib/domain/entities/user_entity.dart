import 'package:flutter/foundation.dart';

/// Entidad de dominio que representa un usuario autenticado.
/// Esta clase es inmutable y pertenece a la capa de dominio (Clean Architecture).
/// No debe tener dependencias externas ni lógica de negocio compleja.
@immutable
class UserEntity {
  /// Identificador único del usuario
  final String id;

  /// Correo electrónico del usuario
  final String email;

  /// Nombre completo del usuario
  final String name;

  /// Token de autenticación (JWT u otro formato)
  final String token;

  /// Constructor constante para garantizar inmutabilidad
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  /// Crea una copia de la entidad con valores opcionales modificados
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  /// Compara dos instancias de UserEntity por valor
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.token == token;
  }

  /// Genera el hash code basado en las propiedades
  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ token.hashCode;
  }

  /// Representación en String para debugging
  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, token: ${token.substring(0, 10)}...)';
  }
}
