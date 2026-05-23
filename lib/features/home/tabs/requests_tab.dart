import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_add_outlined,
            size: 64,
            color: Color(0xFFCCCCCC),
          ),
          const SizedBox(height: 16),
          Text(
            'No Requests Yet',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8c7071),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Interest requests will appear here',
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
