# Development Guide - Thiruvivaha Mobile

## Getting Started

This guide provides detailed instructions for setting up and developing the Thiruvivaha matrimony app.

## Prerequisites

- Flutter SDK: 3.12.0 or higher
- Dart SDK: 3.12.0 or higher
- Android Studio / Xcode (for native development)
- Supabase account with a project
- Git

## First Time Setup

### 1. Install Flutter

```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install

# Add Flutter to PATH
export PATH="$PATH:~/flutter/bin"

# Verify installation
flutter doctor
```

### 2. Clone and Setup Project

```bash
# Clone repository
git clone <repository-url>
cd thiruvivaha_mobile

# Get Flutter dependencies
flutter pub get

# (Optional) Generate build files
flutter pub run build_runner build
```

### 3. Configure Supabase

1. **Create Supabase Account**: https://supabase.com

2. **Create New Project** with:
   - Name: Thiruvivaha
   - Database password: Strong password
   - Region: Closest to your users

3. **Copy Credentials**:
   - Go to Settings → API
   - Copy Project URL (anon key URL)
   - Copy anon public key

4. **Create `.env` file**:
```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
APP_ENV=development
```

### 4. Run the App

```bash
# List connected devices
flutter devices

# Run on emulator/device
flutter run

# Run with specific flavor/configuration
flutter run --debug
```

## Database Setup

### Run Migrations

```bash
# Using Supabase CLI (optional)
supabase link --project-ref <project-id>
supabase migration new create_users_table
```

### Manual Schema Creation

In Supabase Dashboard → SQL Editor, run:

```sql
-- Users table
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone TEXT,
  profile_image_url TEXT,
  bio TEXT,
  gender TEXT,
  date_of_birth DATE,
  religion TEXT,
  caste TEXT,
  occupation TEXT,
  education TEXT,
  location TEXT,
  email_verified BOOLEAN DEFAULT FALSE,
  phone_verified BOOLEAN DEFAULT FALSE,
  profile_complete BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can read own profile"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.users FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.users FOR INSERT
  WITH CHECK (auth.uid() = id);
```

## Development Workflow

### 1. Feature Development

```bash
# Create feature branch
git checkout -b feature/auth-login

# Make changes and test
flutter run

# Hot reload for quick iteration
# Hot restart for state reset
```

### 2. Code Style

Follow Dart conventions:
- Use `camelCase` for variables/functions
- Use `PascalCase` for classes
- Maximum 80 characters per line (soft)
- Format code: `dart format .`
- Analyze code: `dart analyze`

### 3. Testing

```bash
# Run unit tests
flutter test

# Run specific test file
flutter test test/features/auth/auth_test.dart

# Run tests with coverage
flutter test --coverage
```

### 4. Debugging

```bash
# Enable debug logging
flutter run -vvv

# Use DevTools
flutter pub global activate devtools
devtools

# Attach DevTools to running app
flutter attach
```

## Project Organization

### Adding New Feature

```
features/new_feature/
├── presentation/
│   ├── pages/
│   │   └── new_feature_page.dart
│   ├── widgets/
│   │   └── new_feature_widget.dart
│   └── providers/
│       └── new_feature_provider.dart
├── data/
│   ├── datasources/
│   │   └── new_feature_remote_datasource.dart
│   └── repositories/
│       └── new_feature_repository.dart
└── domain/
    ├── entities/
    │   └── new_feature_entity.dart
    └── usecases/
        └── new_feature_usecase.dart
```

### File Naming Convention

- **Pages**: `feature_page.dart`
- **Widgets**: `widget_name_widget.dart`
- **Providers**: `feature_provider.dart`
- **Data Sources**: `feature_remote_datasource.dart`
- **Repositories**: `feature_repository.dart`
- **Entities**: `entity_name.dart`
- **Models**: `entity_name_model.dart`
- **Tests**: `feature_test.dart` (in `test/` directory)

## Common Development Tasks

### Add a New Route

```dart
// In main.dart or separate routing file
routes: {
  '/login': (context) => const LoginPage(),
  '/home': (context) => const HomePage(),
  '/profile': (context) => const ProfilePage(),
}
```

### Add Form Validation

```dart
// Create in core/utils/validators.dart
static String? validateCustomField(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (value.length < 3) {
    return 'Minimum 3 characters required';
  }
  return null;
}

// Use in CustomTextField
CustomTextField(
  validator: Validators.validateCustomField,
)
```

### Make API Call

```dart
// 1. Create DataSource
class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final SupabaseClient client;
  
  @override
  Future<List<Feature>> getFeatures() async {
    try {
      final response = await client
          .from('features')
          .select();
      return (response as List)
          .map((e) => Feature.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

// 2. Create Repository
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  
  @override
  Future<List<Feature>> getFeatures() async {
    return await remoteDataSource.getFeatures();
  }
}

// 3. Create Provider
final featuresProvider = FutureProvider<List<Feature>>((ref) async {
  final repo = ref.watch(featureRepositoryProvider);
  return repo.getFeatures();
});

// 4. Use in Widget
final features = ref.watch(featuresProvider);
```

### Handle Loading/Error States

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(someProvider);

  return state.when(
    data: (data) => ListView(children: ...),
    loading: () => const CircularProgressIndicator(),
    error: (error, stack) => ErrorWidget(error: error),
  );
}
```

## Deployment

### iOS Deployment

```bash
# Build iOS app
flutter build ios --release

# Create IPA for App Store
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build
```

### Android Deployment

```bash
# Build APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### Web Deployment

```bash
# Build web
flutter build web --release

# Deploy to hosting platform
# Files are in build/web/
```

## Useful Commands

```bash
# Format code
dart format .

# Analyze code
dart analyze

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Clean build
flutter clean

# Run specific device
flutter run -d <device-id>

# Run tests with coverage
flutter test --coverage

# Generate build files
flutter pub run build_runner build

# Watch for changes and rebuild
flutter pub run build_runner watch
```

## Performance Tips

1. Use `const` constructors
2. Avoid rebuilds with `Riverpod` selectors
3. Lazy load images with `CachedNetworkImage`
4. Implement pagination for lists
5. Use `ListView.builder` instead of `ListView`
6. Profile with DevTools Performance tab

## Security Best Practices

1. Never commit `.env` files
2. Use environment variables for secrets
3. Validate all user inputs
4. Sanitize API responses
5. Use HTTPS for all API calls
6. Implement token refresh logic
7. Store sensitive data securely

## Troubleshooting

### App won't build
```bash
flutter clean
flutter pub get
flutter pub upgrade --major-versions
```

### Supabase connection fails
- Check `.env` credentials
- Verify project is active
- Check internet connectivity
- Review Supabase logs

### State not updating
- Ensure using `ref.watch()` in build
- Check Riverpod DevTools
- Verify provider dependencies

### Hot reload not working
```bash
# Use hot restart
# Or run flutter run -vvv to debug
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Docs](https://supabase.io/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)

## Support

For issues or questions:
1. Check existing issues
2. Search documentation
3. Ask in team channel
4. Create detailed bug report

---

Happy coding! 🚀
