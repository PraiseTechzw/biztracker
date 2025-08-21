#!/bin/bash

# BizTracker Rollback Script
# Use this script if you need to rollback a problematic release

echo "⚠️  BizTracker Rollback Script"
echo "This script helps you rollback to a previous version"
echo ""

# Check if version is provided
if [ -z "$1" ]; then
    echo "❌ Error: Please provide the version to rollback to"
    echo "Usage: ./rollback_release.sh <version>"
    echo "Example: ./rollback_release.sh 1.0.0"
    exit 1
fi

ROLLBACK_VERSION=$1

echo "🔄 Rolling back to version: $ROLLBACK_VERSION"
echo ""

# Update pubspec.yaml version
echo "📝 Updating pubspec.yaml version..."
sed -i "s/version: .*/version: $ROLLBACK_VERSION+1/" pubspec.yaml

# Clean and rebuild
echo "🧹 Cleaning and rebuilding..."
flutter clean
flutter pub get

# Build rollback version
echo "📱 Building rollback version..."
flutter build appbundle --release

echo "✅ Rollback build completed!"
echo ""
echo "📁 Rollback bundle: build/app/outputs/bundle/release/app-release.aab"
echo "🚀 Upload this bundle to Play Console to rollback the release"
echo ""
echo "💡 Remember to:"
echo "   1. Upload the rollback bundle to Play Console"
echo "   2. Set it as the active release"
echo "   3. Monitor for any issues"
echo "   4. Investigate the original problem before next release"
