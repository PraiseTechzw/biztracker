#!/bin/bash

# BizTracker Dependency Fix Script
# This script fixes common dependency and build issues

echo "🔧 BizTracker Dependency Fix Script"
echo ""

# Clean everything
echo "🧹 Cleaning project..."
flutter clean
cd android
./gradlew clean
cd ..

# Clear pub cache for problematic packages
echo "🗑️  Clearing pub cache for problematic packages..."
flutter pub cache clean

# Get dependencies fresh
echo "📦 Getting fresh dependencies..."
flutter pub get

# Generate Isar models
echo "🔧 Generating Isar models..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for dependency conflicts
echo "🔍 Checking for dependency conflicts..."
flutter pub deps

echo ""
echo "✅ Dependency fix completed!"
echo ""
echo "💡 If you still encounter issues:"
echo "   1. Try: flutter doctor -v"
echo "   2. Check: flutter pub outdated"
echo "   3. Consider updating Flutter SDK"
echo "   4. Run: flutter build apk --debug to test"
