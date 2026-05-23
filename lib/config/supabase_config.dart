import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => Supabase.instance.client.auth;

  static Future<String?> getAccessToken() async {
    try {
      final session = auth.currentSession;
      return session?.accessToken;
    } catch (e) {
      return null;
    }
  }

  static bool isAuthenticated() => auth.currentUser != null;

  static Future<void> signOut() async {
    await auth.signOut();
  }
}
