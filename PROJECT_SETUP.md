# Thiruvivaha Mobile - Project Setup & Architecture Guide

## Project Overview

**Thiruvivaha** is a premium matrimony app built with Flutter and Supabase. It follows a clean architecture pattern with features organized in a modular structure.

## Tech Stack

- **Frontend**: Flutter 3.12+
- **State Management**: Riverpod 2.4+
- **Backend**: Supabase (PostgreSQL + Auth)
- **Storage**: Hive (local), Supabase Storage
- **HTTP Client**: Dio
- **UI Libraries**: Google Fonts, Material 3

## Project Structure

```
lib/
├── config/                          # App configuration
│   ├── theme.dart                  # Material 3 theme with brand colors
│   ├── supabase_config.dart        # Supabase initialization
│   └── constants.dart              # App constants
│
├── core/                            # Shared code
│   ├── errors/
│   │   └── exceptions.dart         # Custom exception classes
│   ├── utils/
│   │   ├── logger.dart             # Logging utility
│   │   └── validators.dart         # Form validation logic
│   └── widgets/
│       ├── custom_button.dart      # Reusable button widget
│       └── custom_text_field.dart  # Reusable text field widget
│
├── features/                        # Feature modules (Clean Architecture)
│   ├── auth/                       # Authentication feature
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── login_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── login_form.dart
│   │   │   │   └── social_login_buttons.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart  # Riverpod state management
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── domain/
│   │       └── entities/
│   │           └── user.dart
│   │
│   └── home/                       # Home feature (placeholder)
│       └── pages/
│           └── home_page.dart
│
└── main.dart                        # App entry point
```

## Architecture Pattern

### Clean Architecture Layers

1. **Presentation Layer** (`presentation/`)
   - UI Components (Pages, Widgets)
   - State Management (Riverpod)
   - User interaction handling

2. **Data Layer** (`data/`)
   - Remote Data Sources (Supabase API)
   - Local Data Sources (Hive)
   - Repositories (combine data sources)

3. **Domain Layer** (`domain/`)
   - Entities (data models)
   - Use Cases (business logic)
   - Repository Interfaces

### State Management with Riverpod

```dart
// Provider definition
final authRepositoryProvider = Provider<AuthRepository>((ref) => ...);

// State notifier for stateful management
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => ...);

// Usage in widgets
final authState = ref.watch(authStateProvider);
ref.read(authStateProvider.notifier).login(email, password);
```

## Setup Instructions

### 1. Environment Setup

```bash
# Clone the repository
git clone <repo-url>

# Navigate to project
cd thiruvivaha_mobile

# Install dependencies
flutter pub get
```

### 2. Environment Configuration

Create `.env` file in the project root:

```env
SUPABASE_URL=https://your-supabase-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key
APP_ENV=development
```

Create `.env.production` for production:

```env
SUPABASE_URL=https://your-production-url.supabase.co
SUPABASE_ANON_KEY=your-production-anon-key
APP_ENV=production
```

### 3. Supabase Setup

#### Database Schema

```sql
-- Create users table
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
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own profile"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON public.users FOR UPDATE
  USING (auth.uid() = id);
```

#### Authentication Setup

1. Go to Supabase Dashboard → Authentication
2. Enable Email/Password authentication
3. Configure OAuth providers (Google, Facebook)
4. Set redirect URL: `io.supabase.thiruvivaha://login-callback`

### 4. Running the App

```bash
# Development
flutter run

# Production build
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

## Color System (from DESIGN.md)

### Primary Colors
- **Primary**: `#7b001f` (Heritage Crimson)
- **Secondary**: `#864e5a` (Petal Rose)
- **Tertiary**: `#4e3700` (Champagne Gold)

### Neutral Colors
- **Surface**: `#f9f9f9` (Alabaster White)
- **Surface Variant**: `#e2e2e2` (Mist Grey)
- **On Surface**: `#1a1c1c` (Dark)
- **Outline**: `#8c7071` (Taupe)

### Semantic Colors
- **Error**: `#ba1a1a` (Red)
- **Success**: Derived from Primary

## Typography

- **Headlines**: Playfair Display (Serif)
- **Body**: Manrope (Sans-serif)
- **Labels**: Manrope Bold

## Features Overview

### Authentication
- ✅ Email/Password Login
- ✅ Email/Password Signup
- ✅ Password Reset
- ⏳ Social Login (Google, Facebook)
- ⏳ Phone Verification
- ⏳ Email Verification

### Profile Management
- ⏳ Profile Creation
- ⏳ Photo Upload (max 6 photos)
- ⏳ Bio & Details
- ⏳ Preferences

### Matching
- ⏳ Profile Discovery
- ⏳ Interest/Like System
- ⏳ Mutual Matches
- ⏳ Messaging

### Notifications
- ⏳ Push Notifications
- ⏳ In-app Notifications

## Dependencies

### Essential
- `supabase_flutter` - Backend
- `flutter_riverpod` - State management
- `google_fonts` - Typography
- `flutter_dotenv` - Environment variables

### Optional (Future)
- `image_picker` - Photo selection
- `permission_handler` - Permissions
- `firebase_messaging` - Push notifications
- `local_auth` - Biometric auth
- `geolocator` - Location services

## Best Practices

### Code Organization
1. Keep features self-contained
2. Use repositories for data abstraction
3. Separate business logic from UI
4. Use meaningful file/class names

### State Management
1. Use Riverpod providers for dependency injection
2. Leverage StateNotifier for complex state
3. Handle loading, error, and success states
4. Implement error boundaries

### Error Handling
1. Use custom exceptions
2. Provide user-friendly error messages
3. Log errors for debugging
4. Implement retry logic where needed

### UI/UX
1. Follow Material Design 3 guidelines
2. Respect the color system
3. Use consistent typography
4. Implement proper loading states
5. Show meaningful feedback to users

## Common Tasks

### Adding a New Feature

1. Create feature folder in `lib/features/`
2. Add `domain/`, `data/`, `presentation/` layers
3. Implement entities and use cases
4. Create data sources and repositories
5. Build UI with state management
6. Add navigation routes

### Adding a New Page

```dart
// 1. Create page in features/feature_name/presentation/pages/
class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(...);
}

// 2. Add to main.dart routes (when routing is implemented)
```

### Adding Form Validation

```dart
// Use Validators utility
String? Function(String?)? validator = (value) {
  if (value == null || value.isEmpty) {
    return 'Field is required';
  }
  return null;
};

// Or use built-in validators
CustomTextField(
  validator: Validators.validateEmail,
  ...
)
```

## Troubleshooting

### Supabase Connection Issues
- Verify `.env` file has correct credentials
- Check Supabase project is active
- Verify network connectivity

### Build Errors
```bash
# Clean build
flutter clean
flutter pub get
flutter pub upgrade --major-versions
```

### State Management Issues
- Ensure Riverpod ProviderScope wraps the app
- Check provider dependencies
- Use DevTools for debugging

## Resources

- [Flutter Documentation](https://flutter.dev)
- [Supabase Documentation](https://supabase.io/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Clean Architecture in Flutter](https://resocoder.com)

## Contributors

- Project Lead: Thiruvivaha Team

## License

Proprietary - All rights reserved
