# 🎨 Pantalla de Login - Presentación UI

Esta carpeta contiene la implementación de la **interfaz de usuario** de la pantalla de Login, basada en el diseño creado en Pencil.

## 📁 Estructura

```
lib/pages/login/
├── login_page.dart                      ✅ Página principal
├── widgets/
│   ├── email_text_field.dart           ✅ Campo de email
│   ├── password_text_field.dart        ✅ Campo de contraseña
│   ├── login_button.dart               ✅ Botón de login
│   └── error_message_container.dart    ✅ Contenedor de error
└── README.md                            📖 Esta documentación
```

---

## 🎯 Componentes Implementados

### 1️⃣ LoginPage - Página Principal

**Archivo**: `login_page.dart`

**Funcionalidades:**
- ✅ Integra todos los widgets (email, password, botón, error)
- ✅ Consume `AuthController` con Provider
- ✅ Maneja validación de formulario
- ✅ Gestiona estados de UI (loading, error, autenticado)
- ✅ Navegación automática cuando autenticado
- ✅ Hints de credenciales de prueba

**Estructura de la página:**
```dart
Column(
  - Título y subtítulo
  - EmailTextField
  - PasswordTextField
  - ErrorMessageContainer (condicional)
  - LoginButton (con loading overlay)
  - Hint de credenciales
)
```

---

### 2️⃣ EmailTextField - Campo de Email

**Archivo**: `widgets/email_text_field.dart`

**Especificaciones de Pencil** (`email_input`):
| Propiedad | Valor |
|-----------|-------|
| Label | "Email" |
| Placeholder | "Introduce tu email" |
| Height | 48px |
| Padding | 12px × 16px |
| Border | 1px #D1D5DB |
| Border Radius | 8px |
| Background | #FFFFFF |
| Font Size | 16px |
| Font Family | Inter |

**Características:**
- ✅ Validación de campo requerido
- ✅ Validación de formato email (regex)
- ✅ Keyboard type: emailAddress
- ✅ Text action: next
- ✅ Estados de borde (normal, focus, error, disabled)
- ✅ Habilitado/deshabilitado según `isLoading`

---

### 3️⃣ PasswordTextField - Campo de Contraseña

**Archivo**: `widgets/password_text_field.dart`

**Especificaciones de Pencil** (`password_input`):
| Propiedad | Valor |
|-----------|-------|
| Label | "Contraseña" |
| Placeholder | "Contraseña" |
| Height | 48px |
| Padding | 12px × 16px |
| Border | 1px #D1D5DB |
| Border Radius | 8px |
| Background | #FFFFFF |
| Icono | eye (20×20px, #6B7280) |
| obscureText | true |

**Características:**
- ✅ Texto oculto por defecto (`obscureText: true`)
- ✅ Icono de ojo para toggle visibilidad
- ✅ Validación de campo requerido
- ✅ Validación de longitud mínima (6 caracteres)
- ✅ Text action: done
- ✅ Estados interactivos de visibilidad

---

### 4️⃣ LoginButton - Botón de Inicio de Sesión

**Archivo**: `widgets/login_button.dart`

**Especificaciones de Pencil** (`login_button` + `loading_state_overlay`):

**Estado NORMAL:**
| Propiedad | Valor |
|-----------|-------|
| Background | #3B82F6 (azul primario) |
| Text Color | #FFFFFF (blanco) |
| Height | 48px |
| Width | fill_container |
| Border Radius | 8px |
| Font Size | 16px |
| Font Weight | 600 |

**Estado DISABLED:**
| Propiedad | Valor |
|-----------|-------|
| Background | #E5E7EB (gris claro) |
| Text Color | #9CA3AF (gris medio) |

**Estado LOADING:**
| Propiedad | Valor |
|-----------|-------|
| Overlay Background | rgba(59, 130, 246, 0.1) |
| Spinner Size | 24×24px |
| Spinner Color | #3B82F6 |

**Características:**
- ✅ Tres estados visuales (normal, disabled, loading)
- ✅ Loading overlay superpuesto con `Stack`
- ✅ CircularProgressIndicator centrado
- ✅ Disabled automáticamente cuando `isLoading`

---

### 5️⃣ ErrorMessageContainer - Contenedor de Error

**Archivo**: `widgets/error_message_container.dart`

**Especificaciones de Pencil** (`error_message_container`):
| Propiedad | Valor |
|-----------|-------|
| Background | #FEE2E2 (rojo muy claro) |
| Border | 1px #EF4444 (rojo) |
| Border Radius | 8px |
| Padding | 12px × 16px |
| Gap | 8px (icono-texto) |
| Icon | circle-x (20×20px) |
| Icon Color | #DC2626 |
| Text Color | #DC2626 |
| Font Size | 14px |
| Font Weight | 500 |

**Características:**
- ✅ Solo visible cuando `state.isError`
- ✅ Icono de error a la izquierda
- ✅ Mensaje dinámico desde `AuthException`
- ✅ Ancho completo con texto expandible

---

## 🔄 Flujo de Interacción

```
Usuario abre la app
       ↓
LoginPage se monta
       ↓
checkAuthStatus() automático
       ↓
   ┌───────┴────────┐
   │                │
Sin sesión    Sesión activa
   ↓                ↓
Mostrar login   Navegar a Home


Usuario ingresa credenciales
       ↓
Presiona "Iniciar Sesión"
       ↓
Validación de formulario
       ↓
   ┌───────┴────────┐
   │                │
Válido        Inválido
   ↓                ↓
login()        Mostrar error


Estado cambia a Loading
       ↓
UI muestra:
- Campos disabled
- Botón con spinner
- Error oculto
       ↓
Espera 2 segundos (simulado)
       ↓
   ┌───────┴────────┐
   │                │
 Éxito           Error
   ↓                ↓
AuthAuthenticated   AuthError
   ↓                ↓
SnackBar success   Mostrar error container
   ↓
TODO: Navegar a Home
```

---

## 🎨 Mapeo Diseño Pencil → Flutter

| Componente Pencil | Widget Flutter | Estado de Visibilidad |
|-------------------|----------------|----------------------|
| `email_input` | `EmailTextField` | Siempre visible |
| `password_input` | `PasswordTextField` | Siempre visible |
| `login_button` | `LoginButton` (enabled) | `!isLoading` |
| `login_button_disabled` | `LoginButton` (disabled) | `isLoading` |
| `loading_state_overlay` | Stack overlay en `LoginButton` | `isLoading` |
| `error_message_container` | `ErrorMessageContainer` | `state.isError` |

---

## 💻 Uso de Provider

### Consumir estado en la UI

```dart
// Opción 1: Consumer para UI reactiva (reconstruye)
Consumer<AuthController>(
  builder: (context, authController, child) {
    if (authController.isLoading) {
      return CircularProgressIndicator();
    }
    // ...
  },
)

// Opción 2: context.read para acciones (no reconstruye)
onPressed: () {
  final controller = context.read<AuthController>();
  controller.login(email, password);
}

// Opción 3: context.watch para getters (reconstruye)
final isLoading = context.watch<AuthController>().isLoading;
```

### Escuchar cambios de estado

```dart
@override
void initState() {
  super.initState();

  final controller = context.read<AuthController>();
  controller.addListener(_onAuthStateChanged);
}

void _onAuthStateChanged() {
  final controller = context.read<AuthController>();

  if (controller.state.isAuthenticated) {
    // Navegar a Home
    Navigator.pushReplacementNamed(context, '/home');
  }
}

@override
void dispose() {
  context.read<AuthController>().removeListener(_onAuthStateChanged);
  super.dispose();
}
```

---

## 🧪 Testing Manual

### Credenciales de Prueba
```
Email: test@green.com
Password: 123456
```

### Escenarios de Prueba

1. **Login Exitoso**
   - Ingresar: test@green.com / 123456
   - ✅ Debe mostrar loading 2 segundos
   - ✅ Debe mostrar SnackBar de bienvenida
   - ✅ Campos deben deshabilitarse durante loading

2. **Login Fallido**
   - Ingresar: wrong@email.com / wrong
   - ✅ Debe mostrar loading 2 segundos
   - ✅ Debe mostrar error container
   - ✅ Mensaje: "Email o contraseña incorrectos"

3. **Validación de Email**
   - Dejar email vacío → Error: "El email es requerido"
   - Ingresar "notanemail" → Error: "Introduce un email válido"
   - Ingresar "test@test.com" → Válido ✅

4. **Validación de Password**
   - Dejar vacío → Error: "La contraseña es requerida"
   - Ingresar "123" → Error: "debe tener al menos 6 caracteres"
   - Ingresar "123456" → Válido ✅

5. **Toggle Visibilidad de Password**
   - Presionar icono de ojo
   - ✅ Debe alternar entre visible/oculto
   - ✅ Icono debe cambiar

---

## 🎨 Paleta de Colores

```dart
// Colores primarios
Primary Blue:       #3B82F6
White:              #FFFFFF

// Grises
Dark Gray:          #1F2937  // Títulos, texto
Medium Gray:        #6B7280  // Iconos, subtítulos
Light Gray:         #9CA3AF  // Placeholders, disabled text
Very Light Gray:    #D1D5DB  // Bordes
Disabled Background:#E5E7EB  // Fondo disabled

// Rojos (errores)
Error Dark:         #DC2626  // Texto e iconos de error
Error Medium:       #EF4444  // Bordes de error
Error Light:        #FEE2E2  // Fondo de error
```

---

## 📱 Dimensiones del Diseño

```
Lienzo móvil:     360 × 740 px
Padding general:  16px
Gap entre elementos: 24px

EmailTextField:
  - Height: 48px
  - Padding: 12px × 16px
  - Border radius: 8px

PasswordTextField:
  - Height: 48px
  - Padding: 12px × 16px
  - Border radius: 8px

LoginButton:
  - Height: 48px
  - Width: fill_container
  - Border radius: 8px
  - Padding: 12px × 24px

ErrorContainer:
  - Width: fill_container
  - Padding: 12px × 16px
  - Border radius: 8px
  - Gap: 8px
```

---

## 🚀 Próximos Pasos

1. **Implementar HomeScreen**
   - Crear `lib/pages/home/home_screen.dart`
   - Mostrar información del usuario
   - Botón de logout

2. **Agregar Rutas**
   - Configurar named routes en MaterialApp
   - Navegación entre Login y Home

3. **Implementar Persistencia**
   - Conectar con `AuthLocalDataSource`
   - Guardar sesión con SharedPreferences
   - "Remember me" funcional

4. **Conectar con API Real**
   - Implementar `AuthRemoteDataSource`
   - Reemplazar simulación en `AuthRepositoryImpl`
   - Manejar errores de red

5. **Mejoras de UX**
   - Animaciones de transición
   - Feedback haptic
   - Snackbars personalizados
   - Loading shimmer

---

## ✨ Resumen

| Componente | Estado | Descripción |
|------------|--------|-------------|
| LoginPage | ✅ Completo | Integra todos los widgets |
| EmailTextField | ✅ Completo | Con validación de formato |
| PasswordTextField | ✅ Completo | Con toggle de visibilidad |
| LoginButton | ✅ Completo | Con 3 estados visuales |
| ErrorMessageContainer | ✅ Completo | Diseño fiel a Pencil |
| Provider Setup | ✅ Completo | Configurado en main.dart |

**La UI está completamente funcional y lista para usar!** 🎉
