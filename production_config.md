# BizTracker Production Configuration

## Version Information
- **App Version**: 1.0.0
- **Build Number**: 1
- **Target SDK**: Latest stable
- **Min SDK**: 23 (Android 6.0)

## Production Build Features

### ✅ Enabled for Production
- **ProGuard**: Enabled with optimization
- **Resource Shrinking**: Enabled
- **Code Minification**: Enabled
- **Debug Logging**: Disabled
- **Performance Optimization**: Maximum
- **Security**: Enhanced

### 🔧 Build Configuration
- **Release Mode**: Full optimization
- **Signing**: Release keystore required
- **Target Platforms**: android-arm64
- **Output Formats**: APK + App Bundle (.aab)

## Play Store Requirements

### 📱 App Bundle (.aab)
- **File**: `build/app/outputs/bundle/release/app-release.aab`
- **Size**: Optimized for Play Store
- **Format**: Android App Bundle (recommended)

### 📦 APK (Alternative)
- **File**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: Larger than bundle
- **Format**: Traditional APK

## Build Commands

### Quick Production Build
```bash
./build_production.sh
```

### Manual Build Commands
```bash
# Clean and prepare
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build for production
flutter build appbundle --release
# or
flutter build apk --release
```

## Pre-Release Checklist

- [ ] Version number updated in pubspec.yaml
- [ ] Version display updated in UI
- [ ] ProGuard rules configured
- [ ] Signing configuration ready
- [ ] Code analysis clean
- [ ] Tests passing
- [ ] Assets optimized
- [ ] Privacy policy updated
- [ ] Terms of service ready
- [ ] App store listing prepared

## Post-Release

- [ ] Monitor crash reports
- [ ] Track user feedback
- [ ] Monitor performance metrics
- [ ] Plan next version update 