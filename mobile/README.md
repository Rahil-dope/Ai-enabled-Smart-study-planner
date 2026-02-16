# Smart Study Planner - Mobile App

Flutter mobile application for the Smart Study Planner project.

## 📱 Features

- User authentication (Login/Register)
- Goal creation with AI-powered planning
- Daily task viewing and completion
- Progress tracking and analytics
- Clean, modern UI with Material Design 3

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **MVVM** pattern:

```
lib/
├── core/
│   ├── constants/        # App-wide constants
│   └── theme/           # Theme configuration
├── data/
│   ├── datasources/     # API communication layer
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
└── presentation/
    ├── screens/         # UI screens
    └── viewmodels/      # State management (Provider)
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5              # State management
  dio: ^5.3.3                   # HTTP client
  shared_preferences: ^2.2.2    # Local storage
  flutter_secure_storage: ^9.0.0
  google_fonts: ^6.1.0          # Typography
  intl: ^0.18.1                 # Internationalization
  uuid: ^4.2.1                  # UUID generation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 2.19.0
- Android Studio / Xcode (for device builds)

### Installation

1. **Navigate to mobile directory**
   ```bash
   cd mobile
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (if using code generation)
   ```bash
   flutter pub run build_runner build
   ```

### Running the App

**Development mode:**
```bash
flutter run
```

**Specific device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

### Configuration

Edit `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // Android Emulator
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  
  // iOS Simulator
  // static const String baseUrl = 'http://localhost:3000/api/v1';
  
  // Physical Device
  // static const String baseUrl = 'http://YOUR_IP:3000/api/v1';
  
  static const String tokenKey = 'auth_token';
}
```

## 📱 Screens

### Splash Screen
- Auto-checks for saved authentication token
- Redirects to Login or Dashboard

### Authentication
- **Login Screen**: Email/password login
- **Register Screen**: User registration with validation

### Dashboard
- Displays study statistics (Active Goals, Tasks Done, Study Time)
- Lists all user goals
- Navigate to goal details

### Create Goal
- AI-powered goal creation wizard
- Inputs: Title, Description, Deadline, Daily Commitment, Knowledge Level
- Triggers backend AI planning

### Plan Detail
- Shows daily task breakdown
- Expandable task cards with topics
- Checkbox to mark tasks complete
- Optimistic UI updates

## 🎨 UI/UX Guidelines

### Theme
- **Primary Color**: Indigo (#3F51B5)
- **Secondary Color**: Orange (#FF9800)
- **Typography**: Google Fonts - Inter
- **Material Design**: Version 3

### Components
- Cards with elevation for content grouping
- FAB for primary actions
- Bottom sheets for forms
- Snackbars for feedback

## 🔧 State Management

Uses **Provider** pattern:

```dart
// Registering providers
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (_) => GoalViewModel()),
    ChangeNotifierProvider(create: (_) => TaskViewModel()),
  ],
  child: MaterialApp(...)
)

// Consuming in widgets
final viewModel = Provider.of<GoalViewModel>(context);
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Building for Production

### Android

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK:**
```bash
flutter build apk --release
```

**App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

### iOS

**Release build:**
```bash
flutter build ios --release
```

**IPA (requires Xcode):**
```bash
flutter build ipa
```

## 🐛 Common Issues

### Issue: "flutter command not found"
**Solution:** Add Flutter to PATH:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: Android build fails
**Solution:** Update Android SDK and accept licenses:
```bash
flutter doctor --android-licenses
```

### Issue: HTTP connection refused
**Solution:** 
- Check backend is running
- Use correct IP for device type (10.0.2.2 for Android emulator)
- Disable SSL certificate validation for dev

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Material Design 3](https://m3.material.io/)

## 🤝 Contributing

This is an academic project. For modifications, please follow the established architecture patterns.
