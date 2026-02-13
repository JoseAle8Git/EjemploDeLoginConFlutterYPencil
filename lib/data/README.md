# 📦 Capa de Datos (Data Layer)

Esta carpeta contiene toda la implementación de la **Capa de Datos** según Clean Architecture.

## 📁 Estructura

```
lib/data/
├── models/                      # Modelos de datos (serialización/deserialización)
│   └── user_model.dart         ✅ Implementado
├── repositories/                # Implementaciones de repositorios
│   └── auth_repository_impl.dart  ✅ Implementado (con simulación)
└── datasources/                 # Fuentes de datos (API, local storage)
    ├── auth_remote_datasource.dart  🔜 Preparado para implementar
    └── auth_local_datasource.dart   🔜 Preparado para implementar
```

## 🎯 Componentes Implementados

### ✅ UserModel (`models/user_model.dart`)
- Extiende `UserEntity` del dominio
- Incluye `fromJson()` para deserialización
- Incluye `toJson()` para serialización
- Métodos auxiliares: `fromEntity()`, `empty()`, `copyWith()`

### ✅ AuthRepositoryImpl (`repositories/auth_repository_impl.dart`)
- Implementa la interfaz `AuthRepository`
- **Actualmente en modo simulación**:
  - Login exitoso: `test@green.com` / `123456`
  - Delay simulado: 2 segundos
  - Usuario de prueba generado automáticamente
- Preparado para inyectar datasources reales

### ✅ AuthException (`../core/exceptions/auth_exception.dart`)
- Excepciones personalizadas para errores de autenticación
- Factory methods: `invalidCredentials()`, `networkError()`, `serverError()`, etc.

## 🔜 Próximas Implementaciones

### AuthRemoteDataSource
**Propósito**: Comunicación con API/Backend

**Opciones de implementación**:
1. **HTTP básico** (`package:http`)
2. **Dio** (HTTP avanzado con interceptors)
3. **GraphQL** (`package:graphql_flutter`)
4. **Firebase Auth** (si usas Firebase)

**Ejemplo con HTTP**:
```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw AuthException.invalidCredentials();
    }
  }
}
```

### AuthLocalDataSource
**Propósito**: Almacenamiento local persistente

**Opciones de implementación**:
1. **SharedPreferences** (datos simples clave-valor)
2. **Hive** (NoSQL rápida)
3. **Sqflite** (SQL local)
4. **FlutterSecureStorage** (datos sensibles)

**Ejemplo con SharedPreferences**:
```dart
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  @override
  Future<void> saveUser(UserModel user) async {
    await prefs.setString('user', json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = prefs.getString('user');
    if (userJson == null) return null;
    return UserModel.fromJson(json.decode(userJson));
  }
}
```

## 🔄 Migración de Simulación a Producción

### Paso 1: Implementar DataSources
```bash
# Crear implementaciones concretas
lib/data/datasources/
├── auth_remote_datasource_impl.dart  # NEW
└── auth_local_datasource_impl.dart   # NEW
```

### Paso 2: Actualizar AuthRepositoryImpl
```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;  // ✅ Descomentar
  final AuthLocalDataSource localDataSource;    // ✅ Descomentar

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    // ❌ Eliminar simulación
    // ✅ Usar datasource real
    final userModel = await remoteDataSource.login(email, password);
    await localDataSource.saveUser(userModel);
    return userModel;
  }
}
```

### Paso 3: Configurar Inyección de Dependencias
```dart
// En main.dart o setup de DI
final authRepository = AuthRepositoryImpl(
  remoteDataSource: AuthRemoteDataSourceImpl(
    client: http.Client(),
    baseUrl: 'https://your-api.com',
  ),
  localDataSource: AuthLocalDataSourceImpl(
    prefs: await SharedPreferences.getInstance(),
  ),
);
```

## 📦 Dependencias Recomendadas

Agrega a tu `pubspec.yaml` según necesites:

```yaml
dependencies:
  # HTTP
  http: ^1.1.0              # Cliente HTTP básico
  dio: ^5.4.0               # Cliente HTTP avanzado (opcional)

  # Almacenamiento local
  shared_preferences: ^2.2.2      # Clave-valor simple
  hive: ^2.2.3                    # NoSQL rápida (opcional)
  hive_flutter: ^1.1.0            # Hive para Flutter (opcional)
  flutter_secure_storage: ^9.0.0  # Almacenamiento seguro (opcional)

  # Serialización JSON
  json_annotation: ^4.8.1   # Anotaciones para JSON

dev_dependencies:
  # Generadores de código
  build_runner: ^2.4.7      # Para generar código
  json_serializable: ^6.7.1 # Generador JSON (opcional)
```

## 🧪 Testing

Estructura de tests recomendada:
```
test/data/
├── models/
│   └── user_model_test.dart       # Test serialización/deserialización
├── repositories/
│   └── auth_repository_impl_test.dart  # Test repositorio con mocks
└── datasources/
    ├── auth_remote_datasource_test.dart  # Test llamadas API
    └── auth_local_datasource_test.dart   # Test almacenamiento
```

## 🔐 Seguridad

### Recomendaciones:
1. **Tokens**: Usar `flutter_secure_storage` para tokens JWT
2. **HTTPS**: Todas las llamadas API deben usar HTTPS
3. **Validación**: Validar respuestas del servidor
4. **Timeout**: Configurar timeouts en requests HTTP
5. **Certificados**: Implementar certificate pinning en producción

## 📝 Notas Importantes

- ⚠️ **No guardes contraseñas**: Solo guarda tokens de autenticación
- ⚠️ **Valida respuestas**: Siempre valida la estructura del JSON recibido
- ⚠️ **Manejo de errores**: Convierte todos los errores en `AuthException`
- ⚠️ **Cache inteligente**: Implementa cache con tiempo de expiración
- ⚠️ **Refresh tokens**: Implementa lógica para refrescar tokens expirados
