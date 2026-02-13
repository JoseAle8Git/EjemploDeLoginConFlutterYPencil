// ignore_for_file: unused_local_variable, avoid_print

/// ARCHIVO DE EJEMPLO - NO INCLUIR EN PRODUCCIÓN
/// Este archivo muestra cómo usar la capa de datos implementada.

import 'package:login_flutter/core/exceptions/auth_exception.dart';
import 'package:login_flutter/data/models/user_model.dart';
import 'package:login_flutter/data/repositories/auth_repository_impl.dart';
import 'package:login_flutter/domain/entities/user_entity.dart';
import 'package:login_flutter/domain/repositories/auth_repository.dart';

/// Ejemplo 1: Uso básico del repositorio con simulación
Future<void> exampleBasicLogin() async {
  // Crear instancia del repositorio (en producción, usar DI)
  final AuthRepository authRepository = AuthRepositoryImpl();

  try {
    // Intentar login con credenciales correctas
    print('🔄 Intentando login...');
    final UserEntity user = await authRepository.login(
      'test@green.com',
      '123456',
    );

    print('✅ Login exitoso!');
    print('   Usuario: ${user.name}');
    print('   Email: ${user.email}');
    print('   Token: ${user.token.substring(0, 20)}...');
  } on AuthException catch (e) {
    print('❌ Error de autenticación: ${e.message}');
  } catch (e) {
    print('❌ Error inesperado: $e');
  }
}

/// Ejemplo 2: Manejo de credenciales inválidas
Future<void> exampleInvalidCredentials() async {
  final AuthRepository authRepository = AuthRepositoryImpl();

  try {
    print('🔄 Intentando login con credenciales incorrectas...');
    final user = await authRepository.login(
      'wrong@email.com',
      'wrongpassword',
    );
  } on AuthException catch (e) {
    print('❌ Error esperado: ${e.message}');
    print('   Código: ${e.code}');
  }
}

/// Ejemplo 3: Verificar autenticación
Future<void> exampleCheckAuthentication() async {
  final authRepository = AuthRepositoryImpl();

  // Primero hacer login
  await authRepository.login('test@green.com', '123456');

  // Verificar si está autenticado
  final isAuth = await authRepository.isAuthenticated();
  print('¿Está autenticado? $isAuth');

  // Obtener usuario actual
  final currentUser = await authRepository.getCurrentUser();
  if (currentUser != null) {
    print('Usuario actual: ${currentUser.name}');
  }
}

/// Ejemplo 4: Ciclo completo de autenticación
Future<void> exampleFullAuthCycle() async {
  final authRepository = AuthRepositoryImpl();

  // 1. Verificar estado inicial
  var isAuth = await authRepository.isAuthenticated();
  print('1️⃣ Estado inicial - Autenticado: $isAuth');

  // 2. Hacer login
  print('\n2️⃣ Haciendo login...');
  final user = await authRepository.login('test@green.com', '123456');
  print('   Login exitoso: ${user.name}');

  // 3. Verificar autenticación después del login
  isAuth = await authRepository.isAuthenticated();
  print('\n3️⃣ Después del login - Autenticado: $isAuth');

  // 4. Obtener usuario actual
  final currentUser = await authRepository.getCurrentUser();
  print('\n4️⃣ Usuario actual: ${currentUser?.email ?? "Sin usuario"}');

  // 5. Hacer logout
  print('\n5️⃣ Haciendo logout...');
  await authRepository.logout();
  print('   Logout completado');

  // 6. Verificar estado después del logout
  isAuth = await authRepository.isAuthenticated();
  print('\n6️⃣ Después del logout - Autenticado: $isAuth');
}

/// Ejemplo 5: Serialización y deserialización de UserModel
void exampleUserModelSerialization() {
  print('\n📦 Ejemplo de serialización:');

  // Crear modelo desde JSON (como vendría de una API)
  final jsonData = {
    'id': '123',
    'email': 'test@example.com',
    'name': 'Test User',
    'token': 'jwt_token_here',
  };

  final userModel = UserModel.fromJson(jsonData);
  print('Usuario desde JSON:');
  print('  ID: ${userModel.id}');
  print('  Email: ${userModel.email}');

  // Convertir modelo a JSON (para guardar o enviar)
  final backToJson = userModel.toJson();
  print('\nUsuario a JSON:');
  print('  $backToJson');

  // Crear una copia con valores modificados
  final updatedUser = userModel.copyWith(name: 'Updated Name');
  print('\nUsuario actualizado:');
  print('  Nombre: ${updatedUser.name}');
  print('  Email: ${updatedUser.email} (sin cambios)');
}

/// Ejemplo 6: Manejo de diferentes tipos de errores
Future<void> exampleErrorHandling() async {
  final authRepository = AuthRepositoryImpl();

  // Mapeo de diferentes escenarios de error
  final testCases = [
    {
      'email': 'test@green.com',
      'password': '123456',
      'description': 'Credenciales correctas'
    },
    {
      'email': 'wrong@email.com',
      'password': '123456',
      'description': 'Email incorrecto'
    },
    {
      'email': 'test@green.com',
      'password': 'wrong',
      'description': 'Contraseña incorrecta'
    },
  ];

  for (final testCase in testCases) {
    print('\n🧪 Probando: ${testCase['description']}');
    try {
      final user = await authRepository.login(
        testCase['email'] as String,
        testCase['password'] as String,
      );
      print('   ✅ Login exitoso: ${user.email}');
    } on AuthException catch (e) {
      print('   ❌ ${e.message} [${e.code}]');
    }
  }
}

/// Función principal para ejecutar todos los ejemplos
/// NO ejecutar en producción - Solo para testing/desarrollo
Future<void> main() async {
  print('═══════════════════════════════════════════════');
  print('   EJEMPLOS DE USO - CAPA DE DATOS');
  print('═══════════════════════════════════════════════\n');

  // Descomentar el ejemplo que quieras probar:

  // await exampleBasicLogin();
  // await exampleInvalidCredentials();
  // await exampleCheckAuthentication();
  // await exampleFullAuthCycle();
  // exampleUserModelSerialization();
  // await exampleErrorHandling();

  print('\n═══════════════════════════════════════════════');
}
