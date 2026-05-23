import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;

  const SocialLoginButtons({super.key, this.onGooglePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              const Expanded(
                child: Divider(color: Color(0xFFe2e2e2), thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8c7071),
                  ),
                ),
              ),
              const Expanded(
                child: Divider(color: Color(0xFFe2e2e2), thickness: 1),
              ),
            ],
          ),
        ),
        SocialButton(
          icon: Icons.g_mobiledata,
          label: 'Continue with Google',
          onPressed: onGooglePressed,
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.color = const Color(0xFFEA4335),
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: const Color(0xFFe0bfbf), width: 1),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
