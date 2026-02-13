import 'package:flutter/material.dart';

/// Widget de botón de login con estados enabled/disabled y loading overlay.
/// Implementa el diseño especificado en Pencil con ID: login_button
///
/// Especificaciones de diseño:
///
/// Estado NORMAL (enabled):
/// - Background: #3B82F6 (azul primario)
/// - Text color: #FFFFFF (blanco)
/// - Height: 48px
/// - Width: fill_container (ancho completo)
/// - Border Radius: 8px
/// - Padding: 12px vertical, 24px horizontal
/// - Font size: 16, weight: 600
///
/// Estado DISABLED:
/// - Background: #E5E7EB (gris claro)
/// - Text color: #9CA3AF (gris medio)
///
/// Estado LOADING:
/// - Overlay superpuesto con fondo azul transparente
/// - CircularProgressIndicator centrado (24x24px, color #3B82F6)
class LoginButton extends StatelessWidget {
  /// Callback cuando se presiona el botón
  final VoidCallback? onPressed;

  /// Indica si el botón está en estado de carga
  final bool isLoading;

  /// Texto del botón
  final String text;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Iniciar Sesión',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Stack(
        children: [
          // Botón base
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6), // Azul primario
              disabledBackgroundColor: const Color(0xFFE5E7EB), // Gris claro
              foregroundColor: Colors.white,
              disabledForegroundColor: const Color(0xFF9CA3AF), // Gris medio
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),

          // Loading Overlay - solo visible cuando isLoading == true
          if (isLoading)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1), // Azul con 10% opacidad
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF3B82F6), // Azul primario
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
