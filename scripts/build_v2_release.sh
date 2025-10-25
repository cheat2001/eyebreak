#!/bin/bash

# EyeBreak v2.0.0 Release Build Script
# This script builds and packages EyeBreak for distribution

set -e  # Exit on any error

echo "🚀 Building EyeBreak v2.1.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Configuration
VERSION="2.1.0"
APP_NAME="EyeBreak"
BUILD_CONFIG="Release"
SCHEME="EyeBreak"
PROJECT="EyeBreak.xcodeproj"

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/.."
BUILD_DIR="$PROJECT_DIR/Build"
ARCHIVE_PATH="$BUILD_DIR/${APP_NAME}.xcarchive"
EXPORT_PATH="$BUILD_DIR/Export"
DMG_PATH="$BUILD_DIR/${APP_NAME}-v${VERSION}.dmg"
ZIP_PATH="$BUILD_DIR/${APP_NAME}.zip"

echo "📂 Project directory: $PROJECT_DIR"
echo "📦 Build directory: $BUILD_DIR"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi
mkdir -p "$BUILD_DIR"

# Clean Xcode build
echo "🧹 Cleaning Xcode build cache..."
cd "$PROJECT_DIR"
xcodebuild clean -project "$PROJECT" -scheme "$SCHEME" -configuration "$BUILD_CONFIG" > /dev/null 2>&1

# Build archive
echo "🔨 Building archive..."
xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$BUILD_CONFIG" \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    | grep -E "^\*\*|error:|warning:" || true

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Archive build failed!"
    exit 1
fi

echo "✅ Archive created successfully"
echo ""

# Export app
echo "📦 Exporting app..."
mkdir -p "$EXPORT_PATH"
cp -R "$ARCHIVE_PATH/Products/Applications/${APP_NAME}.app" "$EXPORT_PATH/"

if [ ! -d "$EXPORT_PATH/${APP_NAME}.app" ]; then
    echo "❌ Export failed!"
    exit 1
fi

echo "✅ App exported successfully"
echo ""

# Create ZIP
echo "🗜️  Creating ZIP archive..."
cd "$EXPORT_PATH"
zip -r "$ZIP_PATH" "${APP_NAME}.app" > /dev/null
cd "$PROJECT_DIR"

if [ ! -f "$ZIP_PATH" ]; then
    echo "❌ ZIP creation failed!"
    exit 1
fi

ZIP_SIZE=$(du -h "$ZIP_PATH" | cut -f1)
echo "✅ ZIP created: ${APP_NAME}.zip ($ZIP_SIZE)"
echo ""

# Create DMG
echo "💿 Creating DMG..."
if command -v create-dmg &> /dev/null; then
    create-dmg \
        --volname "${APP_NAME} v${VERSION}" \
        --volicon "$PROJECT_DIR/EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-512.png" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "${APP_NAME}.app" 175 190 \
        --hide-extension "${APP_NAME}.app" \
        --app-drop-link 425 190 \
        --no-internet-enable \
        "$DMG_PATH" \
        "$EXPORT_PATH" \
        2>/dev/null || true
else
    echo "⚠️  create-dmg not found, using hdiutil instead..."
    hdiutil create -volname "${APP_NAME} v${VERSION}" \
        -srcfolder "$EXPORT_PATH" \
        -ov -format UDZO \
        "$DMG_PATH"
fi

if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG creation failed!"
    exit 1
fi

DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)
echo "✅ DMG created: ${APP_NAME}-v${VERSION}.dmg ($DMG_SIZE)"
echo ""

# Generate checksums
echo "🔐 Generating checksums..."
cd "$BUILD_DIR"
shasum -a 256 "${APP_NAME}.zip" > "${APP_NAME}.zip.sha256"
shasum -a 256 "${APP_NAME}-v${VERSION}.dmg" > "${APP_NAME}-v${VERSION}.dmg.sha256"

ZIP_SHA=$(cat "${APP_NAME}.zip.sha256" | cut -d' ' -f1)
DMG_SHA=$(cat "${APP_NAME}-v${VERSION}.dmg.sha256" | cut -d' ' -f1)

echo "✅ Checksums generated"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Build Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📦 Build Artifacts:"
echo "   • Archive: $ARCHIVE_PATH"
echo "   • App:     $EXPORT_PATH/${APP_NAME}.app"
echo "   • ZIP:     $ZIP_PATH ($ZIP_SIZE)"
echo "   • DMG:     $DMG_PATH ($DMG_SIZE)"
echo ""
echo "🔐 SHA-256 Checksums:"
echo "   • ZIP: $ZIP_SHA"
echo "   • DMG: $DMG_SHA"
echo ""
echo "📋 Next Steps:"
echo "   1. Test the app: open '$EXPORT_PATH/${APP_NAME}.app'"
echo "   2. Test the DMG: open '$DMG_PATH'"
echo "   3. Create GitHub release with tag v${VERSION}"
echo "   4. Upload DMG and ZIP to the release"
echo "   5. Include checksums in release notes"
echo ""
echo "🎉 Ready for release!"
