#!/bin/bash

# Build script for creating distributable EyeBreak.app
# This creates a Release build ready for distribution

set -e  # Exit on error

echo "🔨 Building EyeBreak for distribution..."
echo ""

# Configuration
PROJECT_NAME="EyeBreak"
SCHEME_NAME="EyeBreak"
CONFIGURATION="Release"
BUILD_DIR="./Build"
ARCHIVE_PATH="$BUILD_DIR/$PROJECT_NAME.xcarchive"
EXPORT_PATH="$BUILD_DIR/Export"
DMG_NAME="EyeBreak-v1.0.0.dmg"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build the archive
echo "📦 Creating archive..."
xcodebuild archive \
  -project "$PROJECT_NAME.xcodeproj" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

# Export the app
echo "📤 Exporting app..."
mkdir -p "$EXPORT_PATH"
cp -R "$ARCHIVE_PATH/Products/Applications/$PROJECT_NAME.app" "$EXPORT_PATH/"

# Create DMG
echo "💿 Creating DMG..."
if command -v create-dmg &> /dev/null; then
    create-dmg \
      --volname "EyeBreak Installer" \
      --volicon "$PROJECT_NAME/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-512.png" \
      --window-pos 200 120 \
      --window-size 600 400 \
      --icon-size 100 \
      --icon "$PROJECT_NAME.app" 175 190 \
      --hide-extension "$PROJECT_NAME.app" \
      --app-drop-link 425 185 \
      "$BUILD_DIR/$DMG_NAME" \
      "$EXPORT_PATH"
else
    echo "⚠️  create-dmg not found. Creating simple DMG..."
    hdiutil create -volname "EyeBreak" -srcfolder "$EXPORT_PATH" -ov -format UDZO "$BUILD_DIR/$DMG_NAME"
fi

# Create zip for GitHub releases
echo "🗜️  Creating ZIP archive..."
cd "$EXPORT_PATH"
zip -r "../$PROJECT_NAME.zip" "$PROJECT_NAME.app"
cd - > /dev/null

echo ""
echo "✅ Build complete!"
echo ""
echo "📁 Output files:"
echo "   App:  $EXPORT_PATH/$PROJECT_NAME.app"
echo "   DMG:  $BUILD_DIR/$DMG_NAME"
echo "   ZIP:  $BUILD_DIR/$PROJECT_NAME.zip"
echo ""
echo "📋 Next steps:"
echo "   1. Test the app in $EXPORT_PATH/$PROJECT_NAME.app"
echo "   2. Create a new GitHub release"
echo "   3. Upload $DMG_NAME and $PROJECT_NAME.zip to the release"
echo ""
echo "🎉 Ready for distribution!"
