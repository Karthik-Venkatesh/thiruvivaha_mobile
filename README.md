# Thiruvivaha - Premium Matrimony App

A beautiful, production-grade matrimony mobile application built with **Flutter** and **Supabase**. Following clean architecture patterns and best practices for scalable, maintainable code.

![Design](https://img.shields.io/badge/Design-Material%203-red?style=flat-square)
![Framework](https://img.shields.io/badge/Framework-Flutter%203.12+-blue?style=flat-square)
![Backend](https://img.shields.io/badge/Backend-Supabase-green?style=flat-square)
![State Management](https://img.shields.io/badge/State-Riverpod-purple?style=flat-square)

## 🎨 Design System

**Brand**: "Sacred Union" - Premium Minimalism with Glassmorphism aesthetic

### Colors
- **Primary**: Heritage Crimson `#7b001f`
- **Secondary**: Petal Rose `#864e5a`  
- **Accent**: Champagne Gold `#4e3700`
- **Background**: Alabaster White `#f9f9f9`

### Typography
- **Headlines**: Playfair Display (Serif)
- **Body**: Manrope (Sans-serif)

See [DESIGN.md](DESIGN.md) for complete design specifications.

## 📱 Features

### Authentication
- ✅ Email/Password Sign In
- ✅ Email/Password Sign Up
- ✅ Password Reset
- ⏳ Social Login (Google, Facebook)
- ⏳ Phone Verification
- ⏳ Email Verification

### Upcoming Features
- Profile Management & Verification
- Photo Upload & Verification
- Profile Discovery & Matching
- Interest & Like System
- Messaging & Chat
- Push Notifications
- Location-based Matching

## 🚀 Quick Start

### Prerequisites
- Flutter 3.12.0+
- Dart 3.12.0+
- Supabase Account

### Installation

```bash
# Clone repository
git clone <repo-url>
cd thiruvivaha_mobile

# Install dependencies
flutter pub get

# Configure environment
cp .env.example .env
# Edit .env with your Supabase credentials

# Run the app
flutter run
```

For detailed setup instructions, see [PROJECT_SETUP.md](PROJECT_SETUP.md).

## 🏗️ Architecture

**Clean Architecture** with three layers:

```
Presentation Layer (UI)
        ↓
  State Management (Riverpod)
        ↓
    Data Layer (Repositories)
        ↓
Domain Layer (Business Logic)
```

### Project Structure
```
lib/
├── config/              # Theme, Supabase, Constants
├── core/                # Shared utilities & widgets
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   └── home/           # Home screen
└── main.dart           # App entry point
```

For detailed architecture documentation, see [ARCHITECTURE.md](ARCHITECTURE.md).

## 📚 Documentation

- **[PROJECT_SETUP.md](PROJECT_SETUP.md)** - Complete setup & configuration
- **[DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)** - Development workflow
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture patterns & best practices
- **[DESIGN.md](DESIGN.md)** - Design system specifications

## 🛠️ Development

### Common Commands

```bash
# Format code
dart format .

# Analyze code
dart analyze

# Run tests
flutter test

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release

# Build Web
flutter build web --release
```

### File Organization

Follow these patterns when adding features:

```
features/feature_name/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── providers/
├── data/
│   ├── datasources/
│   └── repositories/
└── domain/
    ├── entities/
    └── usecases/
```

## 📦 Dependencies

### Key Libraries
- **flutter_riverpod** - State management
- **supabase_flutter** - Backend & Auth
- **google_fonts** - Custom typography
- **flutter_dotenv** - Environment config
- **logger** - Logging

See [pubspec.yaml](pubspec.yaml) for complete dependencies.

## 🔐 Security

- Environment variables for sensitive data (.env)
- Supabase authentication with JWT tokens
- Row-level security (RLS) on database
- Input validation on all forms
- HTTPS for all API calls

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/

# Generate coverage
flutter test --coverage
```

## 📈 Performance

- Material 3 design system
- Optimized rebuilds with Riverpod selectors
- Lazy loading for images
- Efficient state management
- Const constructors throughout

## 🤝 Contributing

1. Create feature branch: `git checkout -b feature/auth-improvements`
2. Make changes following architecture patterns
3. Run tests: `flutter test`
4. Format code: `dart format .`
5. Commit: `git commit -m "feat: add auth improvements"`
6. Push: `git push origin feature/auth-improvements`

## 📝 License

Proprietary - All rights reserved

## 👥 Support

For questions or issues:
1. Check [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)
2. Review existing documentation
3. Contact development team

---

Built with ❤️ for meaningful connections

