#!/bin/bash

# BizTracker Namespace Fix Script
# This script fixes the namespace issue with isar_flutter_libs

echo "🔧 BizTracker Namespace Fix Script"
echo ""

# Check if we're on Windows
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "🪟 Windows detected, using Windows-compatible commands"
    SED_CMD="sed -i"
else
    SED_CMD="sed -i"
fi

echo "🧹 Cleaning project..."
flutter clean

echo "🗑️  Clearing pub cache..."
flutter pub cache clean

echo "📦 Getting fresh dependencies..."
flutter pub get

echo "🔧 Generating Isar models..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo ""
echo "💡 Namespace fix options:"
echo ""
echo "Option 1: Build with bypass flag (immediate fix)"
echo "   flutter build apk --debug --android-skip-build-dependency-validation"
echo ""
echo "Option 2: Try production build with bypass flag"
echo "   flutter build appbundle --release --android-skip-build-dependency-validation"
echo ""
echo "Option 3: Use the fix_dependencies.sh script"
echo "   ./fix_dependencies.sh"
echo ""
echo "✅ Namespace fix preparation completed!"
echo ""
echo "⚠️  If you still get namespace errors, the bypass flag is your best option"
echo "   This is a known issue with some Flutter packages and newer AGP versions"
