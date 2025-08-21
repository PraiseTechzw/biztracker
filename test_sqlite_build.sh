#!/bin/bash

# BizTracker SQLite Migration Test Script
# This script tests if the SQLite migration resolves the namespace issues

echo "🧪 BizTracker SQLite Migration Test Script"
echo ""

# Stop on any error
set -e

echo "🧹 Deep cleaning project..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/

echo "📦 Getting dependencies with SQLite..."
flutter pub get

echo "🔧 Testing build with SQLite..."
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
        echo "🎉 All builds working! The SQLite migration resolved the namespace issue."
        echo ""
        echo "📁 Build outputs:"
        echo "   Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
        echo "   Release Bundle: build/app/outputs/bundle/release/app-release.aab"
        echo ""
        echo "💡 The SQLite migration successfully resolved the namespace issue."
        echo "   You can now use ./build_production.sh for future builds."
        echo ""
        echo "🔍 Summary of changes:"
        echo "   1. ✅ Replaced Isar with SQLite"
        echo "   2. ✅ Updated models to work with SQLite"
        echo "   3. ✅ Created comprehensive database service"
        echo "   4. ✅ Updated main.dart to use SQLite"
        echo "   5. ✅ Resolved all namespace issues"
    else
        echo "❌ Production build failed"
        echo "💡 Check the error messages above"
    fi
else
    echo "❌ Debug build failed"
    echo "💡 Check the error messages above"
fi

echo ""
echo "💡 Benefits of SQLite migration:"
echo "   - No more namespace issues"
echo "   - Better compatibility with AGP 8.3.0+"
echo "   - Standard SQL database"
echo "   - No code generation required"
echo "   - Easier to maintain and debug"
