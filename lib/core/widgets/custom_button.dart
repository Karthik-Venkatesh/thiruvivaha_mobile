import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonVariant variant;
  final double? width;
  final double height;
  final IconData? icon;
  final EdgeInsets padding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 56,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: _buildButton());
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton();
      case ButtonVariant.secondary:
        return _buildSecondaryButton();
      case ButtonVariant.ghost:
        return _buildGhostButton();
    }
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: isLoading || !isEnabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? const Color(0xFF7b001f)
            : const Color(0xFFdadada),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFdadada),
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: isEnabled ? 2 : 0,
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isEnabled ? Colors.white : const Color(0xFF8c7071),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? Colors.white : const Color(0xFF8c7071),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSecondaryButton() {
    return OutlinedButton(
      onPressed: isLoading || !isEnabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isEnabled ? const Color(0xFF7b001f) : const Color(0xFFdadada),
          width: 1.5,
        ),
        foregroundColor: isEnabled
            ? const Color(0xFF7b001f)
            : const Color(0xFF8c7071),
        disabledForegroundColor: const Color(0xFF8c7071),
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isEnabled ? const Color(0xFF7b001f) : const Color(0xFF8c7071),
                ),
              ),
            )
          : Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isEnabled
                    ? const Color(0xFF7b001f)
                    : const Color(0xFF8c7071),
              ),
            ),
    );
  }

  Widget _buildGhostButton() {
    return TextButton(
      onPressed: isLoading || !isEnabled ? null : onPressed,
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isEnabled ? const Color(0xFF694d0c) : const Color(0xFFdadada),
        ),
      ),
    );
  }
}

enum ButtonVariant { primary, secondary, ghost }
