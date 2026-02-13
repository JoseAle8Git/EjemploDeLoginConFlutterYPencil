import 'package:flutter/material.dart';

/// Widget de campo de texto para email.
/// Implementa el diseño especificado en Pencil con ID: email_input
///
/// Especificaciones de diseño:
/// - Label: "Email"
/// - Placeholder: "Introduce tu email"
/// - Height: 48px (input container)
/// - Padding: 12px vertical, 16px horizontal
/// - Border: 1px #D1D5DB
/// - Border Radius: 8px
/// - Background: #FFFFFF
class EmailTextField extends StatelessWidget {
  /// Controller para el texto del email
  final TextEditingController controller;

  /// Indica si el campo está habilitado
  final bool enabled;

  /// Callback cuando cambia el valor
  final ValueChanged<String>? onChanged;

  /// Callback cuando se envía el formulario (tecla Enter)
  final VoidCallback? onSubmitted;

  const EmailTextField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label del campo
        const Text(
          'Email',
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
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'Introduce tu email',
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
            // Validación del email
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El email es requerido';
              }

              // Validación de formato de email
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );

              if (!emailRegex.hasMatch(value)) {
                return 'Introduce un email válido';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
