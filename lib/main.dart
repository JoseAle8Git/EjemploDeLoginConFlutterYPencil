import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'logic/auth_controller.dart';
import 'pages/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

/// Aplicación principal configurada con Provider para gestión de estado.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Crear instancia de AuthController con su repositorio
      create: (context) {
        // Crear repositorio (simulado por ahora)
        final authRepository = AuthRepositoryImpl();

        // Crear controller con el repositorio
        final authController = AuthController(
          authRepository: authRepository,
        );

        // Verificar si hay sesión guardada al iniciar
        authController.checkAuthStatus();

        return authController;
      },
      child: MaterialApp(
        title: 'Login Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Configuración del tema según el diseño de Pencil
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3B82F6), // Azul primario
          ),
          fontFamily: 'Inter', // Fuente usada en el diseño
          useMaterial3: true,
        ),
        // Página inicial
        home: const LoginPage(),
      ),
    );
  }
}
