import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayMatchAvatar extends StatelessWidget {
  const TodayMatchAvatar({
    super.key,
    required this.name,
    required this.age,
    required this.avatarColor,
    required this.primary,
  });

  final String name;
  final int age;
  final Color avatarColor;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primary, width: 2.5),
          ),
          child: ClipOval(
            child: Container(
              color: avatarColor,
              child: Center(
                child: Text(
                  name[0],
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$name, $age',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1a1c1c),
          ),
        ),
      ],
    );
  }
}
