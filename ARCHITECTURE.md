# Project Structure & Best Practices

## Directory Hierarchy

```
thiruvivaha_mobile/
├── lib/
│   ├── config/                    # Configuration & Setup
│   │   ├── theme.dart            # Material 3 theme definition
│   │   ├── supabase_config.dart  # Supabase initialization
│   │   └── constants.dart        # App-wide constants
│   │
│   ├── core/                     # Shared/Common code
│   │   ├── errors/
│   │   │   └── exceptions.dart   # Custom exception classes
│   │   ├── utils/
│   │   │   ├── logger.dart       # Logging
│   │   │   └── validators.dart   # Form validators
│   │   └── widgets/
│   │       ├── custom_button.dart
│   │       └── custom_text_field.dart
│   │
│   ├── features/                 # Feature modules (Clean Architecture)
│   │   ├── auth/                # Auth feature module
│   │   │   ├── presentation/    # UI Layer
│   │   │   │   ├── pages/       # Full pages
│   │   │   │   ├── widgets/     # Reusable widgets
│   │   │   │   └── providers/   # Riverpod state
│   │   │   ├── data/            # Data Layer
│   │   │   │   ├── datasources/ # API/DB calls
│   │   │   │   └── repositories/# Data abstraction
│   │   │   └── domain/          # Business Logic Layer
│   │   │       ├── entities/    # Data models
│   │   │       └── usecases/    # Business logic
│   │   │
│   │   └── [other_features]/   # Repeat pattern for each feature
│   │
│   └── main.dart                # App entry point
│
├── assets/
│   ├── images/                  # App images
│   ├── icons/                   # Icon assets
│   └── fonts/                   # Custom fonts
│
├── test/                        # Unit & Widget tests
├── android/                     # Android native code
├── ios/                         # iOS native code
├── web/                         # Web build
│
├── pubspec.yaml                # Dependencies
├── .env                        # Dev environment
├── .env.production            # Prod environment
├── analysis_options.yaml      # Linting rules
├── PROJECT_SETUP.md           # Setup instructions
├── DEVELOPMENT_GUIDE.md       # Development guide
└── ARCHITECTURE.md            # Architecture documentation
```

## Clean Architecture Pattern

### Layer Responsibilities

#### 1. Presentation Layer (`presentation/`)
**Responsibility**: UI and User Interaction

```dart
// pages/         - Full-screen pages
// widgets/       - Reusable UI components
// providers/     - State management (Riverpod)

// Example structure
auth/presentation/
├── pages/
│   ├── login_page.dart        # Entire login screen
│   └── signup_page.dart
├── widgets/
│   ├── login_form.dart        # Form component
│   ├── password_input.dart    # Input component
│   └── social_buttons.dart    # Social auth buttons
└── providers/
    └── auth_provider.dart     # State management
```

**Key Points**:
- Handle user interactions
- Display UI
- Manage local UI state
- Communicate with business logic via providers

#### 2. Data Layer (`data/`)
**Responsibility**: Data Fetching and Caching

```dart
// datasources/   - Remote and local data sources
// repositories/  - Combine datasources, implement repo interface
// models/        - JSON serialization models

auth/data/
├── datasources/
│   ├── auth_remote_datasource.dart  # Supabase calls
│   └── auth_local_datasource.dart   # Hive/SharedPrefs
├── repositories/
│   └── auth_repository.dart         # Combines datasources
└── models/
    └── user_model.dart              # JSON -> Dart models
```

**Key Points**:
- Fetch data from APIs/DB
- Handle caching
- Implement repository interfaces
- Convert JSON to entities

#### 3. Domain Layer (`domain/`)
**Responsibility**: Business Logic (Independent of Framework)

```dart
// entities/  - Pure Dart data classes
// usecases/  - Business logic operations
// repositories/ - Interface definitions (not implementation)

auth/domain/
├── entities/
│   └── user.dart                    # Pure data model
├── repositories/
│   └── auth_repository.dart         # Interface only
└── usecases/
    ├── login_usecase.dart
    └── signup_usecase.dart
```

**Key Points**:
- No Flutter/Framework imports
- Pure business logic
- Independent and testable
- Repository interfaces only

## Naming Conventions

### Files
```
presentation/
├── pages/
│   └── feature_page.dart        # Full pages
├── widgets/
│   └── feature_widget.dart      # Reusable widgets
│   └── sub_component_widget.dart
└── providers/
    └── feature_provider.dart    # State management

data/
├── datasources/
│   └── feature_remote_datasource.dart
│   └── feature_local_datasource.dart
└── repositories/
    └── feature_repository.dart

domain/
├── entities/
│   └── entity_name.dart
├── usecases/
│   └── action_usecase.dart      # GetUser, CreatePost, etc.
└── repositories/
    └── feature_repository.dart  # Interface
```

### Classes

```dart
// Pages
class LoginPage extends StatelessWidget {}
class ProfilePage extends ConsumerStatefulWidget {}

// Widgets
class CustomButton extends StatelessWidget {}
class LoginForm extends ConsumerStatefulWidget {}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => ...);
final userProvider = FutureProvider<User>((ref) => ...);

// Repositories
abstract class AuthRepository { }
class AuthRepositoryImpl implements AuthRepository { }

// DataSources
abstract class AuthRemoteDataSource { }
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource { }

// Entities
class User { }

// Exceptions
class AuthException implements Exception { }
```

## Dependency Injection with Riverpod

### Provider Types

```dart
// Simple provider
final simpleProvider = Provider<Type>((ref) => Type());

// Future provider (async data)
final asyncProvider = FutureProvider<Type>((ref) async {
  return await repository.fetchData();
});

// State notifier provider (mutable state)
final stateProvider = StateNotifierProvider<StateNotifier, State>((ref) {
  return StateNotifier(initialState);
});

// Family provider (parametrized)
final familyProvider = Provider.family<String, int>((ref, id) {
  return 'Item $id';
});
```

### Provider Usage

```dart
// In widgets
final data = ref.watch(provider);                    // Watch for changes
final notifier = ref.read(provider.notifier);       // Get notifier
ref.listen(provider, (prev, next) => {});          // Listen for changes

// In other providers
final derived = Provider((ref) {
  final base = ref.watch(baseProvider);
  return process(base);
});
```

## State Management Pattern

### Riverpod State Example

```dart
// 1. Define State Class
sealed class AuthState {
  const AuthState();
  
  factory AuthState.initial() => const _Initial();
  factory AuthState.loading() => const _Loading();
  factory AuthState.authenticated(User user) => _Authenticated(user);
  factory AuthState.error(String message) => _Error(message);
}

// 2. Create StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.repository) : super(const AuthState.initial());
  
  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final user = await repository.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

// 3. Create Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(repositoryProvider));
});

// 4. Use in Widget
class LoginWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.maybeWhen(
      authenticated: (user) => HomePage(),
      error: (msg) => ErrorDialog(message: msg),
      loading: () => LoadingDialog(),
      orElse: () => LoginForm(),
    );
  }
}
```

## Error Handling

### Custom Exceptions

```dart
abstract class AppException implements Exception {
  final String message;
  AppException({required this.message});
}

class NetworkException extends AppException {
  NetworkException({required String message}) : super(message: message);
}

class ValidationException extends AppException {
  final Map<String, String> errors;
  ValidationException({
    required String message,
    this.errors = const {},
  }) : super(message: message);
}
```

### Error Handling in DataSources

```dart
Future<User> getUser(String id) async {
  try {
    final response = await supabase.from('users').select().eq('id', id).single();
    return User.fromJson(response);
  } on PostgrestException catch (e) {
    throw ServerException(message: e.message);
  } on SocketException catch (e) {
    throw NetworkException(message: e.message);
  } catch (e) {
    throw UnknownException(message: 'Unknown error: $e');
  }
}
```

## Testing Structure

```
test/
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   └── auth_provider_test.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource_test.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_test.dart
│   │   └── domain/
│   │       └── entities/
│   │           └── user_test.dart
│   │
│   └── [feature_name]/
│
└── core/
    ├── utils/
    │   └── validators_test.dart
    └── errors/
        └── exceptions_test.dart
```

## Example Feature Implementation

### Complete Login Feature

```dart
// 1. Domain Layer - entities/user.dart
class User {
  final String id;
  final String email;
  final String name;
  
  User({required this.id, required this.email, required this.name});
}

// 2. Domain Layer - repositories/auth_repository.dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
}

// 3. Data Layer - datasources/auth_remote_datasource.dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;
  
  Future<User> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return User.fromJson(response.user!.toJson());
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
}

// 4. Data Layer - repositories/auth_repository.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  @override
  Future<User> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }
}

// 5. Presentation Layer - providers/auth_provider.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: ...);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// 6. Presentation Layer - pages/login_page.dart
class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => Center(child: Text(error)),
        authenticated: (user) => HomePage(user: user),
        initial: () => LoginForm(
          onSubmit: (email, password) {
            ref.read(authStateProvider.notifier).login(email, password);
          },
        ),
      ),
    );
  }
}
```

## Best Practices Summary

1. **Separation of Concerns**: Keep layers independent
2. **Single Responsibility**: Each class has one purpose
3. **DRY (Don't Repeat Yourself)**: Reuse widgets and functions
4. **Constants**: Use constants for magic values
5. **Error Handling**: Handle all possible errors gracefully
6. **Logging**: Log important events and errors
7. **Testing**: Write tests for business logic
8. **Documentation**: Comment complex logic
9. **Naming**: Use descriptive and consistent names
10. **Performance**: Use const constructors and avoid unnecessary rebuilds

---

This architecture ensures scalability, maintainability, and testability of the codebase.
