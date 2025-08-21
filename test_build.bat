@echo off
REM BizTracker Test Build Script for Windows
REM This script tests if the bypass flag resolves the namespace issue

echo 🧪 BizTracker Test Build Script for Windows
echo.

REM Clean the project
echo 🧹 Cleaning project...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Generate Isar models
echo 🔧 Generating Isar models...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo 🚀 Testing build with bypass flag...
echo.

REM Try debug build with bypass flag
echo 📱 Testing debug build...
flutter build apk --debug --android-skip-build-dependency-validation
if %errorlevel% equ 0 (
    echo ✅ Debug build successful!
    echo.
    echo 🚀 Now testing production build...
    
    REM Try production build with bypass flag
    flutter build appbundle --release --android-skip-build-dependency-validation
    if %errorlevel% equ 0 (
        echo ✅ Production build successful!
        echo.
        echo 🎉 All builds working! The bypass flag resolved the namespace issue.
        echo.
        echo 📁 Build outputs:
        echo    Debug APK: build/app/outputs/flutter-apk/app-debug.apk
        echo    Release Bundle: build/app/outputs/bundle/release/app-release.aab
    ) else (
        echo ❌ Production build failed even with bypass flag
        echo 💡 Check the error messages above
    )
) else (
    echo ❌ Debug build failed even with bypass flag
    echo 💡 The namespace issue might be deeper than expected
    echo.
    echo 🔧 Try running: fix_namespace_issue.sh
)

pause
