// ignore_for_file: unused_local_variable, avoid_print, prefer_const_constructors

/// ARCHIVO DE EJEMPLO - NO INCLUIR EN PRODUCCIÓN
/// Este archivo muestra cómo usar AuthController con la UI usando Provider.

import 'package:flutter/material.dart';
import 'package:login_flutter/domain/entities/user_entity.dart';
import 'package:provider/provider.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

// ═══════════════════════════════════════════════════════════════════════════
// EJEMPLO 1: Setup en main.dart con Provider
// ═══════════════════════════════════════════════════════════════════════════

void exampleMainSetup() {
  runApp(
    // Proveer el AuthController a toda la app
    ChangeNotifierProvider(
      create: (context) {
        // Crear repositorio
        final authRepository = AuthRepositoryImpl();

        // Crear controller con el repositorio
        final controller = AuthController(authRepository: authRepository);

        // Verificar sesión al iniciar
        controller.checkAuthStatus();

        return controller;
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Login App', home: AuthWrapper());
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EJEMPLO 2: AuthWrapper - Navegación basada en estado
// ═══════════════════════════════════════════════════════════════════════════

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios de estado
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final state = authController.state;

        // Navegar según el estado
        if (state.isAuthenticated) {
          return HomeScreen(); // Usuario autenticado
        } else if (state.isSessionExpired) {
          return LoginScreen(
            message: 'Sesión expirada. Inicia sesión nuevamente',
          );
        } else {
          return LoginScreen(); // Estado inicial o error
        }
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EJEMPLO 3: Login Screen - Pantalla de Login completa
// ═══════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  final String? message;

  const LoginScreen({super.key, this.message});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();

      authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título
                Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),

                // Email TextField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Introduce tu email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El email es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password TextField
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es requerida';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Error Message (solo visible si hay error)
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    if (authController.state is AuthError) {
                      final errorState = authController.state as AuthError;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFEE2E2),
                          border: Border.all(color: Color(0xFFEF4444)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Color(0xFFDC2626),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorState.message,
                                style: TextStyle(
                                  color: Color(0xFFDC2626),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),

                // Login Button con Loading State
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    final isLoading = authController.state.isLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _handleLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B82F6),
                          disabledBackgroundColor: Color(0xFFE5E7EB),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Color(0xFF9CA3AF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF3B82F6),
                                  ),
                                ),
                              )
                            : Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                // Mensaje informativo
                if (widget.message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      widget.message!,
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),

                // Hint de credenciales de prueba
                SizedBox(height: 24),
                Text(
                  'Credenciales de prueba:\ntest@green.com / 123456',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EJEMPLO 4: Home Screen - Pantalla después de login
// ═══════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Botón de logout
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              final authController = context.read<AuthController>();
              authController.logout();
            },
          ),
        ],
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          final user = authController.currentUser;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 64),
                SizedBox(height: 16),
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                if (user != null) ...[
                  Text('Usuario: ${user.name}'),
                  SizedBox(height: 4),
                  Text('Email: ${user.email}'),
                  SizedBox(height: 4),
                  Text('ID: ${user.id}'),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EJEMPLO 5: Uso directo sin Provider (para testing)
// ═══════════════════════════════════════════════════════════════════════════

Future<void> exampleDirectUsage() async {
  // Crear repositorio
  final AuthRepository authRepository = AuthRepositoryImpl();

  // Crear controller
  final authController = AuthController(authRepository: authRepository);

  // Escuchar cambios de estado
  authController.addListener(() {
    print('Estado cambió: ${authController.state}');

    if (authController.state.isLoading) {
      print('⏳ Cargando...');
    } else if (authController.state.isAuthenticated) {
      print('✅ Autenticado: ${authController.currentUser?.email}');
    } else if (authController.state.isError) {
      print('❌ Error: ${authController.errorMessage}');
    }
  });

  // Hacer login
  print('🔄 Intentando login...');
  await authController.login('test@green.com', '123456');

  // Esperar un poco
  await Future.delayed(Duration(seconds: 1));

  // Hacer logout
  print('🔄 Haciendo logout...');
  await authController.logout();

  // Limpiar
  authController.dispose();
}

// ═══════════════════════════════════════════════════════════════════════════
// EJEMPLO 6: Testing con mocks
// ═══════════════════════════════════════════════════════════════════════════

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserEntity> login(String email, String password) async {
    // Simular login mock
    await Future.delayed(Duration(milliseconds: 500));
    throw UnimplementedError();
  }

  @override
  Future logout() async {}

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<bool> isAuthenticated() async => false;
}

void exampleWithMock() {
  final mockRepo = MockAuthRepository();
  final controller = AuthController(authRepository: mockRepo);

  // Usar controller con mock para testing
  // ...
}
