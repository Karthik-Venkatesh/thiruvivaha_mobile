import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 16),
          Text(
            'My Profile',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8c7071),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your profile details will appear here',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: const Color(0xFFAAAAAA),
            ),
          ),
        ],
      ),
    );
  }
}
