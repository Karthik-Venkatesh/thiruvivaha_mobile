import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thiruvivaha_mobile/core/errors/exceptions.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';
import 'package:thiruvivaha_mobile/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSuccessResponse> login(String email, String password);
  Future<AuthSuccessResponse> signup(
    String email,
    String password,
    String fullName,
  );
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> resetPassword(String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<AuthSuccessResponse> login(String email, String password) async {
    try {
      AppLogger.debug('Attempting login for email: $email');

      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthenticationException(message: 'Login failed');
      }

      final user = await _mapAuthUserToEntity(response.user!);

      AppLogger.debug('Login successful for: $email');

      return AuthSuccessResponse(
        accessToken: response.session?.accessToken ?? '',
        refreshToken: response.session?.refreshToken,
        user: user,
      );
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during login: ${e.message}');
      throw AuthenticationException(message: e.message);
    } catch (e) {
      AppLogger.error('Unknown error during login: $e');
      throw UnknownException(message: 'Login failed: $e');
    }
  }

  @override
  Future<AuthSuccessResponse> signup(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      AppLogger.debug('Attempting signup for email: $email');

      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw AuthenticationException(message: 'Signup failed');
      }

      // Create user profile in public.users table
      await supabaseClient.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'email_verified': false,
        'profile_complete': false,
      });

      final user = await _mapAuthUserToEntity(response.user!);

      AppLogger.debug('Signup successful for: $email');

      return AuthSuccessResponse(
        accessToken: response.session?.accessToken ?? '',
        refreshToken: response.session?.refreshToken,
        user: user,
      );
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during signup: ${e.message}');
      throw AuthenticationException(message: e.message);
    } catch (e) {
      AppLogger.error('Unknown error during signup: $e');
      throw UnknownException(message: 'Signup failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.debug('Attempting logout');
      await supabaseClient.auth.signOut();
      AppLogger.debug('Logout successful');
    } catch (e) {
      AppLogger.error('Error during logout: $e');
      throw UnknownException(message: 'Logout failed');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }

      return await _mapAuthUserToEntity(user);
    } catch (e) {
      AppLogger.error('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.debug('Sending password reset email to: $email');
      await supabaseClient.auth.resetPasswordForEmail(email);
      AppLogger.debug('Password reset email sent');
    } catch (e) {
      AppLogger.error('Error sending password reset: $e');
      throw UnknownException(message: 'Failed to send password reset email');
    }
  }

  @override
  Future<void> resetPassword(String newPassword) async {
    try {
      AppLogger.debug('Attempting password reset');
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      AppLogger.debug('Password reset successful');
    } catch (e) {
      AppLogger.error('Error resetting password: $e');
      throw UnknownException(message: 'Failed to reset password');
    }
  }

  Future<UserEntity> _mapAuthUserToEntity(User authUser) async {
    try {
      // Try to fetch additional user data from public.users table
      final userData = await supabaseClient
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();

      return UserEntity(
        id: authUser.id,
        email: authUser.email ?? '',
        fullName: userData['full_name'] as String?,
        phone: userData['phone'] as String?,
        profileImageUrl: userData['profile_image_url'] as String?,
        bio: userData['bio'] as String?,
        gender: userData['gender'] as String?,
        religion: userData['religion'] as String?,
        caste: userData['caste'] as String?,
        occupation: userData['occupation'] as String?,
        education: userData['education'] as String?,
        location: userData['location'] as String?,
        emailVerified: userData['email_verified'] as bool? ?? false,
        phoneVerified: userData['phone_verified'] as bool? ?? false,
        profileComplete: userData['profile_complete'] as bool? ?? false,
        createdAt: DateTime.parse(userData['created_at'] as String),
        updatedAt: DateTime.parse(userData['updated_at'] as String),
      );
    } catch (e) {
      // Fallback if user profile doesn't exist yet
      return UserEntity(
        id: authUser.id,
        email: authUser.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
}
