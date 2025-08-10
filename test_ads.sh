#!/bin/bash

echo "🚀 BizTracker Ad Testing Script"
echo "================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check current directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Please run this script from the BizTracker project root directory"
    exit 1
fi

echo "✅ Running from BizTracker project directory"
echo ""

# Clean and get dependencies
echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo ""

# Check for connected devices
echo "📱 Checking for connected devices..."
flutter devices

echo ""

# Build and run
echo "🏗️  Building and running app..."
echo "Note: This will run in debug mode with test ads enabled"
echo ""

# Run the app
flutter run --debug

echo ""
echo "🎯 Ad Testing Instructions:"
echo "1. Look for the floating action button (bug icon) on the main screen"
echo "2. Tap it to open the Ad Debug Screen"
echo "3. Check the configuration and status sections"
echo "4. Use the test controls to test different ad types"
echo "5. Monitor the console for detailed ad loading logs"
echo ""
echo "🔧 Troubleshooting:"
echo "- If ads fail to load, check your internet connection"
echo "- Test ads should work in debug mode"
echo "- Production ads require proper AdMob setup and approval"
echo "- Check the logs for specific error messages" 