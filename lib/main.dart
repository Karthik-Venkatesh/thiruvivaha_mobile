import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/config/theme.dart';
import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/config/constants.dart';
import 'package:thiruvivaha_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:thiruvivaha_mobile/features/home/pages/home_page.dart';
import 'package:thiruvivaha_mobile/features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: ThiruvivahaTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: authState.maybeWhen(
        authenticated: (_) => const HomePage(),
        loading: () => const _SplashScreen(),
        orElse: () => const LoginPage(),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Color(0xFF7b001f))),
    );
  }
}
