import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShortlistedTab extends StatelessWidget {
  const ShortlistedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border, size: 64, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 16),
          Text(
            'No Shortlisted Profiles',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8c7071),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Profiles you shortlist will appear here',
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
