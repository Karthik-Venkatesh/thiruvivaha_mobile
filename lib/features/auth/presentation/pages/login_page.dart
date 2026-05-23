import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thiruvivaha_mobile/features/auth/presentation/widgets/login_form.dart';
import 'package:thiruvivaha_mobile/features/auth/presentation/widgets/social_login_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo and Title
                Center(
                  child: Column(
                    children: [
                      // Heart Icon in Circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7b001f),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF7b001f,
                              ).withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sacred Union',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: isMobile ? 32 : 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7b001f),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Heading
                Text(
                  'Find Your Soulmate',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1a1c1c),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your details to continue your journey',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF594141),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                // Login Form
                LoginForm(
                  onForgotPasswordPressed: () {
                    // TODO: Navigate to forgot password screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Forgot Password feature coming soon'),
                      ),
                    );
                  },
                  onSignupPressed: () {
                    // TODO: Navigate to signup screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signup feature coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                // Social Login
                SocialLoginButtons(
                  onGooglePressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google login coming soon')),
                    );
                  },
                ),
                const SizedBox(height: 28),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1a1c1c),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Signup feature coming soon'),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7b001f),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
