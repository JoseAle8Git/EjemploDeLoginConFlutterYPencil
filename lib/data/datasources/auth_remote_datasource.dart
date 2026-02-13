import '../models/user_model.dart';

/// Datasource remoto para operaciones de autenticación con API.
/// Esta clase se encarga de las llamadas HTTP a tu backend.
///
/// TODO: Implementar cuando tengas un backend disponible.
/// Posibles implementaciones:
/// - HTTP con package:http
/// - Dio para requests avanzados
/// - GraphQL con package:graphql_flutter
/// - Firebase Authentication
abstract class AuthRemoteDataSource {
  /// Autentica un usuario contra el servidor remoto.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario
  /// - [password]: Contraseña del usuario
  ///
  /// Retorna:
  /// - [Future<UserModel>]: Usuario autenticado con token JWT
  ///
  /// Ejemplo de implementación con HTTP:
  /// ```dart
  /// @override
  /// Future<UserModel> login(String email, String password) async {
  ///   final response = await http.post(
  ///     Uri.parse('$baseUrl/auth/login'),
  ///     headers: {'Content-Type': 'application/json'},
  ///     body: json.encode({
  ///       'email': email,
  ///       'password': password,
  ///     }),
  ///   );
  ///
  ///   if (response.statusCode == 200) {
  ///     final jsonData = json.decode(response.body);
  ///     return UserModel.fromJson(jsonData['user']);
  ///   } else if (response.statusCode == 401) {
  ///     throw AuthException.invalidCredentials();
  ///   } else {
  ///     throw AuthException.serverError();
  ///   }
  /// }
  /// ```
  Future<UserModel> login(String email, String password);

  /// Cierra sesión en el servidor (invalida token).
  ///
  /// Parámetros:
  /// - [token]: Token de autenticación a invalidar
  Future<void> logout(String token);

  /// Valida si un token sigue siendo válido en el servidor.
  ///
  /// Parámetros:
  /// - [token]: Token JWT a validar
  ///
  /// Retorna:
  /// - [Future<bool>]: true si el token es válido, false en caso contrario
  Future<bool> validateToken(String token);

  /// Refresca un token de autenticación expirado.
  ///
  /// Parámetros:
  /// - [refreshToken]: Token de refresco
  ///
  /// Retorna:
  /// - [Future<String>]: Nuevo token de acceso
  Future<String> refreshToken(String refreshToken);
}

// TODO: Crear implementación concreta
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final http.Client client;
//   final String baseUrl;
//
//   AuthRemoteDataSourceImpl({
//     required this.client,
//     required this.baseUrl,
//   });
//
//   // Implementar métodos...
// }
