import '../../domain/entities/user_entity.dart';

/// Modelo de datos para Usuario que extiende la entidad de dominio.
/// Esta clase pertenece a la capa de datos y se encarga de la serialización/deserialización.
/// Hereda de UserEntity para mantener la separación de capas en Clean Architecture.
class UserModel extends UserEntity {
  /// Constructor que delega a la entidad padre
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
  });

  /// Factory constructor para crear una instancia desde JSON.
  /// Se usa para deserializar la respuesta de APIs o almacenamiento local.
  ///
  /// Parámetros:
  /// - [json]: Mapa con los datos del usuario en formato JSON
  ///
  /// Ejemplo de JSON esperado:
  /// ```json
  /// {
  ///   "id": "123",
  ///   "email": "user@example.com",
  ///   "name": "John Doe",
  ///   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  /// Convierte la instancia actual a un `Map<String, dynamic>`.
  /// Se usa para serializar antes de enviar a APIs o guardar localmente.
  ///
  /// Retorna:
  /// - `Map<String, dynamic>` con las propiedades del usuario
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }

  /// Factory constructor para crear una instancia desde UserEntity.
  /// Útil para convertir entidades de dominio a modelos de datos.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      token: entity.token,
    );
  }

  /// Crea una copia del modelo con valores opcionales modificados.
  /// Sobrescribe el método de UserEntity para retornar UserModel.
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  /// Crea una instancia vacía de UserModel.
  /// Útil para estados iniciales o placeholders.
  factory UserModel.empty() {
    return const UserModel(
      id: '',
      email: '',
      name: '',
      token: '',
    );
  }
}
