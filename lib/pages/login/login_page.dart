import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';
import '../../logic/auth_state.dart';
import 'widgets/email_text_field.dart';
import 'widgets/password_text_field.dart';
import 'widgets/login_button.dart';
import 'widgets/error_message_container.dart';

/// Página de Login que implementa el diseño creado en Pencil.
///
/// Componentes del diseño:
/// - email_input: EmailTextField
/// - password_input: PasswordTextField
/// - login_button: LoginButton con loading_state_overlay
/// - error_message_container: ErrorMessageContainer
///
/// Dimensiones del lienzo móvil: 360x740
/// Padding general: 16px
/// Gap entre elementos: 24px
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Key para el formulario (validación)
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Escuchar cambios de estado para navegación automática
    final authController = context.read<AuthController>();
    authController.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    // Limpiar controllers
    _emailController.dispose();
    _passwordController.dispose();

    // Remover listener
    final authController = context.read<AuthController>();
    authController.removeListener(_onAuthStateChanged);

    super.dispose();
  }

  /// Callback cuando cambia el estado de autenticación
  void _onAuthStateChanged() {
    final authController = context.read<AuthController>();

    // Si está autenticado, navegar a Home
    if (authController.state.isAuthenticated) {
      // TODO: Navegar a HomeScreen cuando esté implementada
      // Navigator.pushReplacementNamed(context, '/home');

      // Por ahora mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Bienvenido ${authController.currentUser?.name}!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Maneja el evento de login
  void _handleLogin() {
    // Validar formulario
    if (_formKey.currentState!.validate()) {
      // Obtener controller
      final authController = context.read<AuthController>();

      // Ejecutar login
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60), // Espaciado superior

                // Título de la pantalla
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),

                // Subtítulo
                const Text(
                  'Ingresa tus credenciales para continuar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 32),

                // Email TextField
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return EmailTextField(
                      controller: _emailController,
                      enabled: !authController.isLoading,
                      onSubmitted: _handleLogin,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Password TextField
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return PasswordTextField(
                      controller: _passwordController,
                      enabled: !authController.isLoading,
                      onSubmitted: _handleLogin,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Error Message Container - solo visible si hay error
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    if (authController.state is AuthError) {
                      final errorState = authController.state as AuthError;
                      return Column(
                        children: [
                          ErrorMessageContainer(
                            message: errorState.message,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Login Button con Loading Overlay
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return LoginButton(
                      onPressed: _handleLogin,
                      isLoading: authController.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Hint de credenciales de prueba
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Credenciales de prueba:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Email: test@green.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Contraseña: 123456',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
