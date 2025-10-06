#!/bin/bash
# Quick DMG Creator - Uses existing built app

set -e

echo "🎨 Creating user-friendly DMG with Applications shortcut..."

# Use the already-built app
APP_PATH="Build/Export/EyeBreak.app"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found at: $APP_PATH"
    echo "💡 Run ./scripts/build_release.sh first"
    exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "📁 Created temp directory: $TEMP_DIR"

# Copy app
echo "📋 Copying app..."
cp -R "$APP_PATH" "$TEMP_DIR/"

# Create Applications symlink (this is the key!)
echo "🔗 Creating Applications shortcut..."
ln -s /Applications "$TEMP_DIR/Applications"

# Create a nice README
cat > "$TEMP_DIR/Install Instructions.txt" << 'EOF'
📥 How to Install EyeBreak

1. Drag "EyeBreak.app" to the "Applications" folder
2. Eject this disk image
3. Open Applications folder and find EyeBreak
4. Right-click EyeBreak → Select "Open"
5. Click "Open" in the security dialog
6. Look for the 👁️ icon in your menu bar!

⚠️ Important: You must right-click → Open the first time
(This is because the app isn't code-signed)

📚 Documentation: https://github.com/cheat2001/eyebreak
🐛 Report Issues: https://github.com/cheat2001/eyebreak/issues

Remember: Every 20 minutes, look 20 feet away for 20 seconds! 👁️✨
EOF

# Create DMG
DMG_NAME="EyeBreak-v1.0.0.dmg"
echo "💿 Creating DMG: $DMG_NAME"

# Remove old DMG if exists
rm -f "Build/$DMG_NAME"

# Create the DMG with nice settings
hdiutil create \
    -volname "EyeBreak" \
    -srcfolder "$TEMP_DIR" \
    -ov \
    -format UDZO \
    -imagekey zlib-level=9 \
    "Build/$DMG_NAME"

# Cleanup
rm -rf "$TEMP_DIR"

# Show result
echo ""
echo "✅ DMG created successfully!"
echo "📍 Location: Build/$DMG_NAME"
echo "📦 Size: $(du -h "Build/$DMG_NAME" | cut -f1)"
echo ""
echo "🎉 Ready to distribute!"
echo ""
echo "To test:"
echo "  open Build/$DMG_NAME"
echo ""
