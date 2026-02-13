import 'package:flutter/material.dart';

/// Widget que muestra un mensaje de error.
/// Implementa el diseño especificado en Pencil con ID: error_message_container
///
/// Especificaciones de diseño:
/// - Background: #FEE2E2 (rojo muy claro)
/// - Border: 1px sólido #EF4444 (rojo)
/// - Border Radius: 8px
/// - Padding: 12px vertical, 16px horizontal
/// - Gap: 8px entre icono y texto
/// - Icono: circle-x de Lucide, 20x20px, color #DC2626 (rojo oscuro)
/// - Texto: fontSize 14, fontWeight 500, color #DC2626
///
/// Solo visible cuando state.isError == true
class ErrorMessageContainer extends StatelessWidget {
  /// Mensaje de error a mostrar
  final String message;

  const ErrorMessageContainer({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2), // Rojo muy claro
        border: Border.all(
          color: const Color(0xFFEF4444), // Rojo
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icono de error (circle-x)
          const Icon(
            Icons.cancel, // Equivalente a circle-x de Lucide
            size: 20,
            color: Color(0xFFDC2626), // Rojo oscuro
          ),
          const SizedBox(width: 8),

          // Mensaje de error
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFDC2626), // Rojo oscuro
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
