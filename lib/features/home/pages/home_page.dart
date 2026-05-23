import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thiruvivaha',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF7b001f),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: Color(0xFF7b001f), size: 80),
            const SizedBox(height: 20),
            Text(
              'Welcome to Thiruvivaha',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF7b001f),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your matrimony journey starts here',
              style: GoogleFonts.manrope(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
