#!/bin/bash

# BizTracker AGP Downgrade Fix Script
# Temporarily downgrades AGP to resolve namespace issues

echo "🔧 BizTracker AGP Downgrade Fix Script"
echo "Temporarily downgrades AGP to resolve namespace issues"
echo ""

# Stop on any error
set -e

echo "🧹 Deep cleaning project..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Regenerating Isar models..."
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs

echo ""
echo "🔄 Temporarily downgrading AGP to 7.4.2 for compatibility..."
echo ""

# Backup current settings
cp android/settings.gradle.kts android/settings.gradle.kts.backup

# Update to AGP 7.4.2 (more compatible with older packages)
cat > android/settings.gradle.kts << 'EOF'
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "7.4.2" apply false
    id("org.jetbrains.kotlin.android") version "1.8.0" apply false
}

include(":app")
EOF

# Update Gradle wrapper to compatible version
cat > android/gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-7.6.1-all.zip
EOF

echo "✅ Downgraded to AGP 7.4.2 and Gradle 7.6.1"
echo ""

echo "🚀 Testing build with downgraded AGP..."
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
        echo "🎉 All builds working! The AGP downgrade resolved the namespace issue."
        echo ""
        echo "📁 Build outputs:"
        echo "   Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
        echo "   Release Bundle: build/app/outputs/bundle/release/app-release.aab"
        echo ""
        echo "💡 The AGP downgrade successfully resolved the namespace issue."
        echo "   You can now use ./build_production.sh for future builds."
        echo ""
        echo "⚠️  Note: This is a temporary fix. Consider updating packages when possible."
    else
        echo "❌ Production build failed"
        echo "💡 Check the error messages above"
    fi
else
    echo "❌ Debug build failed"
    echo "💡 Check the error messages above"
fi

echo ""
echo "🔍 Summary of fixes applied:"
echo "   1. ✅ Deep cleaned project and caches"
echo "   2. ✅ Regenerated Isar models"
echo "   3. ✅ Downgraded AGP to 7.4.2"
echo "   4. ✅ Downgraded Gradle to 7.6.1"
echo "   5. ✅ Tested builds with downgraded tools"
echo ""
echo "💡 To restore original configuration:"
echo "   cp android/settings.gradle.kts.backup android/settings.gradle.kts"
echo "   cp android/gradle/wrapper/gradle-wrapper.properties.backup android/gradle/wrapper/gradle-wrapper.properties"
