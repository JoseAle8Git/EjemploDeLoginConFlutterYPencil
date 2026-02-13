import 'package:flutter/material.dart';

/// Widget de campo de texto para contraseña.
/// Implementa el diseño especificado en Pencil con ID: password_input
///
/// Especificaciones de diseño:
/// - Label: "Contraseña"
/// - Placeholder: "Contraseña" (representado como ••••••••)
/// - Height: 48px (input container)
/// - Padding: 12px vertical, 16px horizontal
/// - Border: 1px #D1D5DB
/// - Border Radius: 8px
/// - Background: #FFFFFF
/// - Icono de ojo: 20x20px, color #6B7280, a la derecha
/// - obscureText: true (texto oculto por defecto)
class PasswordTextField extends StatefulWidget {
  /// Controller para el texto de la contraseña
  final TextEditingController controller;

  /// Indica si el campo está habilitado
  final bool enabled;

  /// Callback cuando cambia el valor
  final ValueChanged<String>? onChanged;

  /// Callback cuando se envía el formulario (tecla Enter)
  final VoidCallback? onSubmitted;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  /// Controla si la contraseña está visible u oculta
  bool _obscureText = true;

  /// Alterna la visibilidad de la contraseña
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label del campo
        const Text(
          'Contraseña',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937), // Gris oscuro
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),

        // Input container
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: widget.controller,
            enabled: widget.enabled,
            obscureText: _obscureText,
            textInputAction: TextInputAction.done,
            onChanged: widget.onChanged,
            onFieldSubmitted:
                widget.onSubmitted != null ? (_) => widget.onSubmitted!() : null,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'Contraseña',
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Color(0xFF9CA3AF), // Gris medio para placeholder
                fontFamily: 'Inter',
              ),
              filled: true,
              fillColor: const Color(0xFFFFFFFF), // Blanco
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              // Icono de ojo a la derecha
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF6B7280), // Gris
                ),
                onPressed: widget.enabled ? _togglePasswordVisibility : null,
                splashRadius: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1D5DB), // Gris claro
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1D5DB),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6), // Azul primario al enfocar
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFEF4444), // Rojo para errores
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFEF4444),
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB), // Gris muy claro cuando disabled
                  width: 1,
                ),
              ),
            ),
            // Validación de la contraseña
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es requerida';
              }

              // Validación mínima de longitud (opcional)
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
