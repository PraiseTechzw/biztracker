# BizTracker Production Configuration

## Version Information
- **App Version**: 1.0.1
- **Build Number**: 2
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
- **Multi-Architecture Support**: Enabled

### 🔧 Build Configuration
- **Release Mode**: Full optimization
- **Signing**: Release keystore required
- **Target Platforms**: Multi-architecture (armeabi-v7a, arm64-v8a, x86_64)
- **Output Formats**: APK + App Bundle (.aab)
- **Universal APK**: Enabled for compatibility

## Play Store Requirements

### 📱 App Bundle (.aab)
- **File**: `build/app/outputs/bundle/release/app-release.aab`
- **Size**: Optimized for Play Store
- **Format**: Android App Bundle (recommended)
- **Architecture Support**: Multi-ABI for maximum compatibility

### 📦 APK (Alternative)
- **File**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: Larger than bundle
- **Format**: Universal APK with all architectures
- **Compatibility**: Ensures existing users can upgrade

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

# Build for production (multi-architecture)
flutter build appbundle --release
# or
flutter build apk --release
```

### Rollback Build (if needed)
```bash
./rollback_release.sh <version>
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
- [ ] Multi-architecture support verified
- [ ] Compatibility with existing users confirmed

## Post-Release

- [ ] Monitor crash reports
- [ ] Track user feedback
- [ ] Monitor performance metrics
- [ ] Plan next version update
- [ ] Verify upgrade path for existing users

## Troubleshooting

### Common Issues
1. **Upgrade Compatibility Error**: Ensure multi-architecture support
2. **AAB Rollout Issues**: Use universal APK as fallback
3. **Version Conflicts**: Check version codes and names

### Rollback Procedure
1. Use rollback script: `./rollback_release.sh <version>`
2. Upload rollback bundle to Play Console
3. Set as active release
4. Investigate original issue 