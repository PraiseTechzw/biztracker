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

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

# Run tests (if any)
echo "🧪 Running tests..."
flutter test

# Build APK for production (multi-architecture support)
echo "📱 Building production APK (multi-architecture)..."
flutter build apk --release --android-skip-build-dependency-validation

# Build App Bundle for Play Store (multi-architecture support)
echo "📦 Building App Bundle for Play Store (multi-architecture)..."
flutter build appbundle --release --android-skip-build-dependency-validation

echo "✅ Production build completed!"
echo ""
echo "📁 Build outputs:"
echo "   APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   Bundle: build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "🚀 Ready for Play Store submission!"
echo ""
echo "💡 Note: Multi-architecture builds ensure compatibility with existing users"
echo "⚠️  Using --android-skip-build-dependency-validation flag for compatibility" 