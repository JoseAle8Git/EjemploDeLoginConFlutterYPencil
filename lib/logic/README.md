# 🧠 Capa de Lógica (Logic Layer)

Esta carpeta contiene la **gestión de estado** para la pantalla de Login usando el patrón **Controller/ViewModel** con `ChangeNotifier`.

## 📁 Estructura

```
lib/logic/
├── auth_state.dart                      ✅ Estados de autenticación
├── auth_controller.dart                 ✅ Controller con ChangeNotifier
├── EXAMPLE_USAGE_CONTROLLER.dart        📝 Ejemplos de integración
└── README.md                            📖 Esta documentación
```

---

## 🎯 Componentes Implementados

### 1️⃣ AuthState - Clase de Estados

**Estados disponibles:**

| Estado | Descripción | Cuándo usarlo |
|--------|-------------|---------------|
| `AuthInitial` | Estado inicial | App recién abierta, después de logout |
| `AuthLoading` | Procesando autenticación | Durante login/logout |
| `AuthAuthenticated` | Usuario autenticado | Login exitoso |
| `AuthError` | Error de autenticación | Credenciales inválidas, error de red |
| `AuthSessionExpired` | Sesión expirada | Token JWT expirado |

**Propiedades:**

```dart
// AuthAuthenticated contiene el usuario
class AuthAuthenticated extends AuthState {
  final UserEntity user;
}

// AuthError contiene mensaje y código
class AuthError extends AuthState {
  final String message;
  final String? code;
}
```

**Extensiones útiles:**

```dart
state.isInitial        // true si es AuthInitial
state.isLoading        // true si es AuthLoading
state.isAuthenticated  // true si es AuthAuthenticated
state.isError          // true si es AuthError
state.userOrNull       // UserEntity? o null
state.errorMessageOrNull // String? o null
```

---

### 2️⃣ AuthController - Gestor de Estado

**Características:**
- ✅ Extiende `ChangeNotifier` (listeners de Flutter)
- ✅ Gestiona el estado de autenticación
- ✅ Se conecta con la capa de dominio (AuthRepository)
- ✅ Maneja errores con `AuthException`
- ✅ Notifica automáticamente a la UI de cambios

**Métodos principales:**

```dart
class AuthController extends ChangeNotifier {
  // Estado actual
  AuthState get state;

  // Autenticar usuario
  Future<void> login(String email, String password);

  // Cerrar sesión
  Future<void> logout();

  // Verificar sesión al iniciar app
  Future<void> checkAuthStatus();

  // Limpiar error
  void clearError();

  // Marcar sesión expirada
  void markSessionExpired();

  // Getters útiles
  UserEntity? get currentUser;
  bool get isAuthenticated;
  bool get isLoading;
  bool get hasError;
  String? get errorMessage;
}
```

---

## 🚀 Uso Básico (Sin Provider)

### Opción 1: Uso directo con StatefulWidget

```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();

    // Crear controller
    final authRepository = AuthRepositoryImpl();
    _authController = AuthController(authRepository: authRepository);

    // Escuchar cambios
    _authController.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    setState(() {
      // La UI se reconstruirá cuando el estado cambie
    });

    // Navegar si está autenticado
    if (_authController.state.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handleLogin() {
    _authController.login(
      emailController.text,
      passwordController.text,
    );
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthStateChanged);
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _authController.state;

    return Scaffold(
      body: Column(
        children: [
          // Email TextField
          TextField(...),

          // Password TextField
          TextField(...),

          // Error Message
          if (state.isError)
            Text(
              state.errorMessageOrNull ?? 'Error desconocido',
              style: TextStyle(color: Colors.red),
            ),

          // Login Button
          ElevatedButton(
            onPressed: state.isLoading ? null : _handleLogin,
            child: state.isLoading
                ? CircularProgressIndicator()
                : Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎨 Uso con Provider (Recomendado)

### Paso 1: Agregar dependencia

```yaml
# pubspec.yaml
dependencies:
  provider: ^6.1.1
```

### Paso 2: Setup en main.dart

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final authRepository = AuthRepositoryImpl();
        final controller = AuthController(authRepository: authRepository);

        // Verificar sesión al iniciar
        controller.checkAuthStatus();

        return controller;
      },
      child: MyApp(),
    ),
  );
}
```

### Paso 3: Consumir en la UI

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Escuchar cambios de estado
          Consumer<AuthController>(
            builder: (context, authController, child) {
              if (authController.state.isError) {
                return ErrorMessage(
                  message: authController.errorMessage!,
                );
              }
              return SizedBox.shrink();
            },
          ),

          // Botón de login
          Consumer<AuthController>(
            builder: (context, authController, child) {
              return ElevatedButton(
                onPressed: authController.isLoading
                    ? null
                    : () {
                        // Obtener controller sin rebuilds
                        final controller = context.read<AuthController>();
                        controller.login(email, password);
                      },
                child: authController.isLoading
                    ? CircularProgressIndicator()
                    : Text('Iniciar Sesión'),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🔄 Flujo de Estados en Login

```
┌─────────────────────────────────────────────────────────┐
│ 1. Estado Inicial                                       │
│    AuthInitial()                                        │
│    ↓ Usuario presiona "Iniciar Sesión"                 │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ 2. Estado de Carga                                      │
│    AuthLoading()                                        │
│    • UI muestra CircularProgressIndicator              │
│    • Botón disabled                                     │
│    ↓ Llamada al repositorio (2 segundos de delay)      │
└─────────────────────────────────────────────────────────┘
                          ↓
                  ┌───────┴───────┐
                  │               │
        ✅ Éxito  │               │  ❌ Error
                  ↓               ↓
┌───────────────────────┐  ┌──────────────────────────┐
│ 3a. Autenticado       │  │ 3b. Error                │
│ AuthAuthenticated(    │  │ AuthError(               │
│   user: UserEntity    │  │   message: "Email o..."  │
│ )                     │  │   code: "INVALID_..."    │
│                       │  │ )                        │
│ • Navegar a Home      │  │ • Mostrar mensaje error  │
│ • Guardar token       │  │ • Mantener en login      │
└───────────────────────┘  └──────────────────────────┘
```

---

## 🎯 Integración con Diseño de Pencil

Tu diseño en Pencil tiene estos componentes que se mapean al estado:

| Componente Pencil | Estado | Condición |
|-------------------|--------|-----------|
| `email_input` | Siempre visible | - |
| `password_input` | Siempre visible | - |
| `login_button` | Enabled/Disabled | `!state.isLoading` |
| `login_button_disabled` | Visible | `state.isLoading` |
| `error_message_container` | Visible | `state.isError` |
| `loading_state_overlay` | Visible | `state.isLoading` |

**Ejemplo de implementación:**

```dart
Widget build(BuildContext context) {
  return Consumer<AuthController>(
    builder: (context, controller, child) {
      return Column(
        children: [
          // Email Input - siempre visible
          EmailTextField(
            enabled: !controller.isLoading,
          ),

          // Password Input - siempre visible
          PasswordTextField(
            enabled: !controller.isLoading,
          ),

          // Error Container - solo si hay error
          if (controller.state.isError)
            ErrorMessageContainer(
              message: controller.errorMessage!,
            ),

          // Login Button con Loading Overlay
          Stack(
            children: [
              // Botón
              LoginButton(
                onPressed: controller.isLoading
                    ? null
                    : () => controller.login(email, password),
              ),

              // Loading Overlay superpuesto
              if (controller.isLoading)
                LoadingStateOverlay(),
            ],
          ),
        ],
      );
    },
  );
}
```

---

## 🧪 Testing

### Test de Estados

```dart
test('Login exitoso debe cambiar a AuthAuthenticated', () async {
  // Arrange
  final mockRepo = MockAuthRepository();
  final controller = AuthController(authRepository: mockRepo);

  // Act
  await controller.login('test@green.com', '123456');

  // Assert
  expect(controller.state, isA<AuthAuthenticated>());
  expect(controller.isAuthenticated, true);
  expect(controller.currentUser, isNotNull);
});

test('Login fallido debe cambiar a AuthError', () async {
  // Arrange
  final mockRepo = MockAuthRepository();
  final controller = AuthController(authRepository: mockRepo);

  // Act
  await controller.login('wrong@email.com', 'wrong');

  // Assert
  expect(controller.state, isA<AuthError>());
  expect(controller.hasError, true);
  expect(controller.errorMessage, isNotNull);
});
```

---

## 📝 Casos de Uso Comunes

### 1. Verificar sesión al abrir la app

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final controller = AuthController(
          authRepository: AuthRepositoryImpl(),
        );

        // Verificar sesión guardada
        controller.checkAuthStatus();

        return controller;
      },
      child: MaterialApp(...),
    );
  }
}
```

### 2. Navegación automática después de login

```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    // Escuchar cambios de estado
    final controller = context.read<AuthController>();
    controller.addListener(_handleAuthChange);
  }

  void _handleAuthChange() {
    final controller = context.read<AuthController>();

    if (controller.state.isAuthenticated) {
      // Navegar a Home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    context.read<AuthController>().removeListener(_handleAuthChange);
    super.dispose();
  }
}
```

### 3. Logout con confirmación

```dart
Future<void> _handleLogout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Cerrar sesión'),
      content: Text('¿Estás seguro?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Sí, cerrar sesión'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final controller = context.read<AuthController>();
    await controller.logout();

    // Navegar a login
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

### 4. Manejar sesión expirada

```dart
// En tu HttpClient o interceptor
if (response.statusCode == 401) {
  // Token expirado
  final controller = context.read<AuthController>();
  controller.markSessionExpired();

  // Mostrar mensaje
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Sesión expirada. Inicia sesión nuevamente')),
  );

  // Navegar a login
  Navigator.pushReplacementNamed(context, '/login');
}
```

---

## 🔒 Mejores Prácticas

1. ✅ **Siempre dispose del controller** si lo usas sin Provider
2. ✅ **Usa `context.read()` para acciones** (no reconstruye)
3. ✅ **Usa `Consumer` para UI reactiva** (reconstruye cuando cambia)
4. ✅ **Verifica sesión al iniciar la app** con `checkAuthStatus()`
5. ✅ **Navega después de autenticar**, no dentro del controller
6. ✅ **Limpia errores** después de mostrarlos con `clearError()`
7. ✅ **Usa `addListener`** para navegación automática
8. ❌ **No guardes BuildContext** dentro del controller
9. ❌ **No hagas navegación** dentro del controller

---

## 🎉 Resumen

| Componente | Estado | Descripción |
|------------|--------|-------------|
| `auth_state.dart` | ✅ Completo | 5 estados + extensiones |
| `auth_controller.dart` | ✅ Completo | ChangeNotifier con 10+ métodos |
| Ejemplos | 📝 Completos | Con y sin Provider |

**La capa de lógica está lista para conectarse con la UI!** 🚀
