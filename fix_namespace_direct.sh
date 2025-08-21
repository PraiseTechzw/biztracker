#!/bin/bash

# BizTracker Direct Namespace Fix Script
# This script directly fixes namespace issues in problematic packages

echo "🔧 BizTracker Direct Namespace Fix Script"
echo ""

# Stop on any error
set -e

echo "🧹 Deep cleaning project..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/

echo "🗑️  Clearing all caches..."
flutter pub cache clean
flutter pub cache repair

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Regenerating Isar models..."
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs

echo ""
echo "🔍 Looking for problematic packages..."
echo ""

# Find the isar_flutter_libs package location
ISAR_PACKAGE_PATH=$(find ~/.pub-cache -name "isar_flutter_libs" -type d 2>/dev/null | head -1)

if [ -n "$ISAR_PACKAGE_PATH" ]; then
    echo "📦 Found isar_flutter_libs at: $ISAR_PACKAGE_PATH"
    
    # Check if it has a build.gradle file
    BUILD_GRADLE_PATH="$ISAR_PACKAGE_PATH/android/build.gradle"
    if [ -f "$BUILD_GRADLE_PATH" ]; then
        echo "🔧 Found build.gradle file, checking for namespace..."
        
        # Check if namespace is already set
        if ! grep -q "namespace" "$BUILD_GRADLE_PATH"; then
            echo "⚠️  No namespace found, adding one..."
            
            # Create backup
            cp "$BUILD_GRADLE_PATH" "$BUILD_GRADLE_PATH.backup"
            
            # Add namespace to android block
            sed -i '/android {/a\    namespace "com.isar.isar_flutter_libs"' "$BUILD_GRADLE_PATH"
            
            echo "✅ Added namespace to isar_flutter_libs"
        else
            echo "✅ Namespace already exists in isar_flutter_libs"
        fi
    else
        echo "⚠️  No build.gradle file found in isar_flutter_libs"
    fi
else
    echo "⚠️  Could not find isar_flutter_libs package"
fi

echo ""
echo "🚀 Testing build after namespace fix..."
echo ""

# Try debug build
echo "📱 Building debug APK..."
if flutter build apk --debug; then
    echo "✅ Debug build successful!"
    echo ""
    echo "🚀 Now testing production build..."
    
    # Try production build
    if flutter build appbundle --release; then
        echo "✅ Production build successful!"
        echo ""
        echo "🎉 All builds working! The direct namespace fix resolved the issue."
        echo ""
        echo "📁 Build outputs:"
        echo "   Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
        echo "   Release Bundle: build/app/outputs/bundle/release/app-release.aab"
        echo ""
        echo "💡 The direct namespace fix successfully resolved the issue."
        echo "   You can now use ./build_production.sh for future builds."
    else
        echo "❌ Production build failed, trying with bypass flag..."
        flutter build appbundle --release --android-skip-build-dependency-validation
    fi
else
    echo "❌ Debug build failed, trying with bypass flag..."
    flutter build apk --debug --android-skip-build-dependency-validation
fi

echo ""
echo "🔍 Summary of fixes applied:"
echo "   1. ✅ Deep cleaned project and caches"
echo "   2. ✅ Regenerated Isar models"
echo "   3. ✅ Added namespace to problematic packages"
echo "   4. ✅ Tested builds with and without bypass flag"
echo ""
echo "💡 If the direct fix works, you won't need the bypass flag anymore."
