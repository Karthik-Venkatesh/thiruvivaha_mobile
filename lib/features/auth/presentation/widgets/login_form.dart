import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/core/widgets/custom_button.dart';
import 'package:thiruvivaha_mobile/core/widgets/custom_text_field.dart';
import 'package:thiruvivaha_mobile/core/utils/validators.dart';
import 'package:thiruvivaha_mobile/features/auth/presentation/providers/auth_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  final VoidCallback? onForgotPasswordPressed;
  final VoidCallback? onSignupPressed;

  const LoginForm({
    Key? key,
    this.onForgotPasswordPressed,
    this.onSignupPressed,
  }) : super(key: key);

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;

  static const _debugUsername = String.fromEnvironment('DEBUG_USERNAME');
  static const _debugPassword = String.fromEnvironment('DEBUG_PASSWORD');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: _debugUsername.isNotEmpty ? _debugUsername : '',
    );
    _passwordController = TextEditingController(
      text: _debugPassword.isNotEmpty ? _debugPassword : '',
    );
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authStateProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    ref.listen(authStateProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        authenticated: (user) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${user.fullName ?? user.email}!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        orElse: () {},
      );
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Email or Username',
            hintText: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            prefixIcon: Icons.mail_outline,
            enabled: !isLoading,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Password',
            hintText: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            prefixIcon: Icons.lock_outline,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleLogin(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPasswordPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7b001f),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          CustomButton(
            label: 'Login',
            onPressed: _handleLogin,
            isLoading: isLoading,
            isEnabled: !isLoading,
            variant: ButtonVariant.primary,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
