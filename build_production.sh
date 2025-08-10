#!/bin/bash

# BizTracker Production Build Script
# This script builds the app for production release

echo "🚀 Starting BizTracker Production Build..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate Isar models
echo "🔧 Generating Isar models..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

# Run tests (if any)
echo "🧪 Running tests..."
flutter test

# Build APK for production
echo "📱 Building production APK..."
flutter build apk --release --target-platform android-arm64

# Build App Bundle for Play Store
echo "📦 Building App Bundle for Play Store..."
flutter build appbundle --release --target-platform android-arm64

echo "✅ Production build completed!"
echo ""
echo "📁 Build outputs:"
echo "   APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   Bundle: build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "🚀 Ready for Play Store submission!" 