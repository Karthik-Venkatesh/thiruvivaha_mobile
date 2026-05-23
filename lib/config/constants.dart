class AppConstants {
  // App Info
  static const String appName = 'Thiruvivaha';
  static const String appVersion = '1.0.0';

  // API Timeouts (in seconds)
  static const int apiTimeoutDuration = 30;
  static const int uploadTimeoutDuration = 60;

  // Validation
  static const int minPasswordLength = 8;
  static const int minBioLength = 10;
  static const int maxBioLength = 500;
  static const int maxPhotoCount = 6;

  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String isDarkModeKey = 'is_dark_mode';
  static const String languageKey = 'language';

  // Routes
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String matchesRoute = '/matches';

  // Durations
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Social Login Providers
  static const String googleProvider = 'google';

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
  static const String invalidCredentials = 'Invalid email or password.';
}
