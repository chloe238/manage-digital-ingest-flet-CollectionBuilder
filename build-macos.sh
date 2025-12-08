#!/bin/bash
# Script to build macOS app with webview fix
# This script works around the Flet 0.28.2 / Flutter 3.29.2 incompatibility

set -e

echo "🔧 Starting macOS build with webview fix..."

# Run flet build up to the point where it creates the Flutter project
echo "📦 Running flet build (will fail, but that's expected)..."
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    .venv/bin/flet build macos --skip-flutter-doctor 2>&1 | tee build-output.log || true
    
    # Check if Flutter project was created
    if [ -f "build/flutter/pubspec.yaml" ]; then
        echo "✅ Flutter project created successfully"
        break
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
        echo "⚠️  Flutter project not created. Retrying in 5 seconds... (Attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)"
        sleep 5
    fi
done

if [ ! -f "build/flutter/pubspec.yaml" ]; then
    echo "❌ Flutter project not created after $MAX_RETRIES attempts."
    echo "This is likely due to GitHub being down. Please try again later."
    exit 1
fi

echo "✅ Flutter project created"

# Fix the pubspec.yaml
echo "🔧 Fixing webview_flutter_android version..."
cd build/flutter

# Replace webview_flutter_android version in pubspec.yaml
if grep -q "webview_flutter_android:" pubspec.yaml; then
    # Use sed to replace the version
    sed -i.bak 's/webview_flutter_android: \^4\.0\.0/webview_flutter_android: 3.16.0/' pubspec.yaml
    echo "✅ Updated webview_flutter_android to 3.16.0"
else
    echo "⚠️  webview_flutter_android not found in pubspec.yaml"
fi

# Update Flutter dependencies
echo "📥 Updating Flutter dependencies..."
/Users/BestChlo2016/flutter/3.29.2/bin/flutter pub get

# Build the macOS app
echo "🏗️  Building macOS application..."
/Users/BestChlo2016/flutter/3.29.2/bin/flutter build macos

# Copy the built app to the standard location
echo "📋 Copying built app..."
cd ../..
mkdir -p build/macos
cp -R "build/flutter/build/macos/Build/Products/Release/Manage Digital Ingest.app" "build/macos/MDI.app"

echo ""
echo "🎉 Build complete!"
echo "📁 App location: build/macos/MDI.app"
echo ""
echo "To open the app:"
echo "  open build/macos/MDI.app"
