#!/bin/bash

# BizTracker Test Build Script
# This script tests if the bypass flag resolves the namespace issue

echo "🧪 BizTracker Test Build Script"
echo ""

# Clean the project
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate Isar models
echo "🔧 Generating Isar models..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo ""
echo "🚀 Testing build with bypass flag..."
echo ""

# Try debug build with bypass flag
echo "📱 Testing debug build..."
if flutter build apk --debug --android-skip-build-dependency-validation; then
    echo "✅ Debug build successful!"
    echo ""
    echo "🚀 Now testing production build..."
    
    # Try production build with bypass flag
    if flutter build appbundle --release --android-skip-build-dependency-validation; then
        echo "✅ Production build successful!"
        echo ""
        echo "🎉 All builds working! The bypass flag resolved the namespace issue."
        echo ""
        echo "📁 Build outputs:"
        echo "   Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
        echo "   Release Bundle: build/app/outputs/bundle/release/app-release.aab"
    else
        echo "❌ Production build failed even with bypass flag"
        echo "💡 Check the error messages above"
    fi
else
    echo "❌ Debug build failed even with bypass flag"
    echo "💡 The namespace issue might be deeper than expected"
    echo ""
    echo "🔧 Try running: ./fix_namespace_issue.sh"
fi
