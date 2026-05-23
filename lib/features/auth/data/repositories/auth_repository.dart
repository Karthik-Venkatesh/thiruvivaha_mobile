import 'package:thiruvivaha_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:thiruvivaha_mobile/features/auth/domain/entities/user.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';

abstract class AuthRepository {
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

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthSuccessResponse> login(String email, String password) async {
    try {
      AppLogger.debug('Repository: Login attempt for $email');
      return await remoteDataSource.login(email, password);
    } catch (e) {
      AppLogger.error('Repository: Login error - $e');
      rethrow;
    }
  }

  @override
  Future<AuthSuccessResponse> signup(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      AppLogger.debug('Repository: Signup attempt for $email');
      return await remoteDataSource.signup(email, password, fullName);
    } catch (e) {
      AppLogger.error('Repository: Signup error - $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.debug('Repository: Logout attempt');
      return await remoteDataSource.logout();
    } catch (e) {
      AppLogger.error('Repository: Logout error - $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      AppLogger.error('Repository: Get current user error - $e');
      return null;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.debug('Repository: Send password reset for $email');
      return await remoteDataSource.sendPasswordResetEmail(email);
    } catch (e) {
      AppLogger.error('Repository: Send password reset error - $e');
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String newPassword) async {
    try {
      AppLogger.debug('Repository: Reset password attempt');
      return await remoteDataSource.resetPassword(newPassword);
    } catch (e) {
      AppLogger.error('Repository: Reset password error - $e');
      rethrow;
    }
  }
}
