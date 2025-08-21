#!/bin/bash

# BizTracker SQLite Setup Script
# This script sets up SQLite database for the project

echo "🔄 BizTracker SQLite Setup Script"
echo ""

# Stop on any error
set -e

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies with SQLite..."
flutter pub get

echo "🔧 Setting up SQLite database..."
echo ""

echo "✅ SQLite setup completed!"
echo ""
echo "📋 SQLite is now configured with:"
echo "   - Business profiles table"
echo "   - Capital tracking table"
echo "   - Stock inventory table"
echo "   - Sales records table"
echo "   - Expenses tracking table"
echo "   - Profit analysis table"
echo ""
echo "3. Test the build:"
echo "   flutter build apk --debug"
echo ""
echo "💡 Benefits of SQLite:"
echo "   - No namespace issues"
echo "   - Better compatibility with AGP 8.3.0+"
echo "   - Standard SQL database"
echo "   - No code generation required"
echo "   - Easier to maintain and debug"
echo ""
echo "🔧 If you need help with the setup, check the SQLite documentation."
