import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;
import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';
import 'package:thiruvivaha_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:thiruvivaha_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:thiruvivaha_mobile/features/auth/domain/entities/user.dart';

// Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseClient = SupabaseConfig.client;
  final remoteDataSource = AuthRemoteDataSourceImpl(
    supabaseClient: supabaseClient,
  );
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
});

// State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<dynamic>? _authSubscription;

  AuthNotifier(this._authRepository) : super(const AuthState.loading()) {
    _initialize();
  }

  /// Restores an existing session on app launch, then subscribes to
  /// Supabase auth changes (token refresh, sign-out, etc.).
  Future<void> _initialize() async {
    try {
      final user = await _authRepository.getCurrentUser();
      state = user != null
          ? AuthState.authenticated(user)
          : const AuthState.initial();
    } catch (e) {
      AppLogger.error('AuthNotifier: Session restore error - $e');
      state = const AuthState.initial();
    }

    // Reactively handle auth changes from Supabase (token refresh, sign-out).
    _authSubscription = SupabaseConfig.auth.onAuthStateChange.listen(
      (data) async {
        final event = data.event;
        AppLogger.debug('AuthNotifier: auth event - $event');
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.tokenRefreshed ||
            event == AuthChangeEvent.userUpdated) {
          final user = await _authRepository.getCurrentUser();
          if (user != null) state = AuthState.authenticated(user);
        } else if (event == AuthChangeEvent.signedOut) {
          state = const AuthState.initial();
        }
      },
      onError: (e) {
        AppLogger.error('AuthNotifier: auth stream error - $e');
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      AppLogger.debug('AuthNotifier: Login for $email');
      final response = await _authRepository.login(email, password);
      state = AuthState.authenticated(response.user);
      AppLogger.debug('AuthNotifier: Login successful');
    } catch (e) {
      AppLogger.error('AuthNotifier: Login error - $e');
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signup(String email, String password, String fullName) async {
    state = const AuthState.loading();
    try {
      AppLogger.debug('AuthNotifier: Signup for $email');
      final response = await _authRepository.signup(email, password, fullName);
      state = AuthState.authenticated(response.user);
      AppLogger.debug('AuthNotifier: Signup successful');
    } catch (e) {
      AppLogger.error('AuthNotifier: Signup error - $e');
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      AppLogger.debug('AuthNotifier: Logout');
      await _authRepository.logout();
      state = const AuthState.initial();
      AppLogger.debug('AuthNotifier: Logout successful');
    } catch (e) {
      AppLogger.error('AuthNotifier: Logout error - $e');
      state = AuthState.error(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);
    } catch (e) {
      AppLogger.error('AuthNotifier: Password reset error - $e');
      state = AuthState.error(e.toString());
    }
  }

  void clearError() {
    state = const AuthState.initial();
  }
}

// State
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(UserEntity user)? authenticated,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    return switch (this) {
      _Initial() => initial?.call() ?? orElse(),
      _Loading() => loading?.call() ?? orElse(),
      _Authenticated(:final user) => authenticated?.call(user) ?? orElse(),
      _Error(:final message) => error?.call(message) ?? orElse(),
    };
  }

  bool get isAuthenticated => this is _Authenticated;
  bool get isLoading => this is _Loading;
  UserEntity? get user => switch (this) {
    _Authenticated(:final user) => user,
    _ => null,
  };
}

final class _Initial extends AuthState {
  const _Initial();
}

final class _Loading extends AuthState {
  const _Loading();
}

final class _Authenticated extends AuthState {
  @override
  final UserEntity user;

  const _Authenticated(this.user);

  @override
  String toString() => 'Authenticated(user: $user)';
}

final class _Error extends AuthState {
  final String message;

  const _Error(this.message);

  @override
  String toString() => 'Error(message: $message)';
}
