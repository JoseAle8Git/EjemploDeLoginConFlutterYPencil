import '../models/user_model.dart';

/// Datasource local para operaciones de autenticación con almacenamiento persistente.
/// Esta clase se encarga del cache y persistencia de datos de usuario.
///
/// TODO: Implementar con una solución de almacenamiento local.
/// Posibles implementaciones:
/// - SharedPreferences (datos simples, clave-valor)
/// - Hive (base de datos NoSQL rápida y ligera)
/// - Sqflite (base de datos SQL local)
/// - Secure Storage (datos sensibles encriptados)
/// - GetStorage (alternativa ligera a SharedPreferences)
abstract class AuthLocalDataSource {
  /// Guarda el usuario autenticado en almacenamiento local.
  ///
  /// Parámetros:
  /// - [user]: Usuario a guardar
  ///
  /// Ejemplo de implementación con SharedPreferences:
  /// ```dart
  /// @override
  /// Future<void> saveUser(UserModel user) async {
  ///   final prefs = await SharedPreferences.getInstance();
  ///   final userJson = json.encode(user.toJson());
  ///   await prefs.setString('cached_user', userJson);
  /// }
  /// ```
  ///
  /// Ejemplo con Hive:
  /// ```dart
  /// @override
  /// Future<void> saveUser(UserModel user) async {
  ///   final box = await Hive.openBox<UserModel>('auth');
  ///   await box.put('current_user', user);
  /// }
  /// ```
  Future<void> saveUser(UserModel user);

  /// Obtiene el usuario guardado en almacenamiento local.
  ///
  /// Retorna:
  /// - [Future<UserModel?>]: Usuario si existe, null en caso contrario
  ///
  /// Ejemplo de implementación con SharedPreferences:
  /// ```dart
  /// @override
  /// Future<UserModel?> getUser() async {
  ///   final prefs = await SharedPreferences.getInstance();
  ///   final userJson = prefs.getString('cached_user');
  ///
  ///   if (userJson == null) {
  ///     return null;
  ///   }
  ///
  ///   final userMap = json.decode(userJson);
  ///   return UserModel.fromJson(userMap);
  /// }
  /// ```
  Future<UserModel?> getUser();

  /// Elimina el usuario del almacenamiento local (logout).
  ///
  /// Ejemplo de implementación:
  /// ```dart
  /// @override
  /// Future<void> clearUser() async {
  ///   final prefs = await SharedPreferences.getInstance();
  ///   await prefs.remove('cached_user');
  /// }
  /// ```
  Future<void> clearUser();

  /// Guarda el token de autenticación de forma segura.
  ///
  /// Parámetros:
  /// - [token]: Token JWT a guardar
  ///
  /// Recomendación: Usar flutter_secure_storage para tokens
  /// ```dart
  /// @override
  /// Future<void> saveToken(String token) async {
  ///   const storage = FlutterSecureStorage();
  ///   await storage.write(key: 'auth_token', value: token);
  /// }
  /// ```
  Future<void> saveToken(String token);

  /// Obtiene el token de autenticación guardado.
  ///
  /// Retorna:
  /// - [Future<String?>]: Token si existe, null en caso contrario
  Future<String?> getToken();

  /// Elimina el token de autenticación.
  Future<void> clearToken();

  /// Verifica si hay un usuario autenticado en cache.
  ///
  /// Retorna:
  /// - [Future<bool>]: true si existe usuario guardado, false en caso contrario
  Future<bool> hasUser();
}

// TODO: Crear implementación concreta
// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final SharedPreferences sharedPreferences;
//   // O: final Box<UserModel> hiveBox;
//   // O: final FlutterSecureStorage secureStorage;
//
//   AuthLocalDataSourceImpl({
//     required this.sharedPreferences,
//   });
//
//   static const String _cachedUserKey = 'CACHED_USER';
//   static const String _cachedTokenKey = 'CACHED_TOKEN';
//
//   @override
//   Future<void> saveUser(UserModel user) async {
//     final userJson = json.encode(user.toJson());
//     await sharedPreferences.setString(_cachedUserKey, userJson);
//   }
//
//   @override
//   Future<UserModel?> getUser() async {
//     final userJson = sharedPreferences.getString(_cachedUserKey);
//     if (userJson == null) return null;
//
//     final userMap = json.decode(userJson) as Map<String, dynamic>;
//     return UserModel.fromJson(userMap);
//   }
//
//   @override
//   Future<void> clearUser() async {
//     await sharedPreferences.remove(_cachedUserKey);
//   }
//
//   @override
//   Future<void> saveToken(String token) async {
//     await sharedPreferences.setString(_cachedTokenKey, token);
//   }
//
//   @override
//   Future<String?> getToken() async {
//     return sharedPreferences.getString(_cachedTokenKey);
//   }
//
//   @override
//   Future<void> clearToken() async {
//     await sharedPreferences.remove(_cachedTokenKey);
//   }
//
//   @override
//   Future<bool> hasUser() async {
//     return sharedPreferences.containsKey(_cachedUserKey);
//   }
// }
