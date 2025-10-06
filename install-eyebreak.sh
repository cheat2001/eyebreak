#!/bin/bash
# EyeBreak Easy Installer
# This script removes quarantine and installs EyeBreak

echo "👁️ EyeBreak Easy Installer"
echo "======================================"
echo ""

# Check if DMG exists in Downloads
DMG_PATH="$HOME/Downloads/EyeBreak-v1.0.0.dmg"

if [ ! -f "$DMG_PATH" ]; then
    echo "📥 Downloading EyeBreak..."
    curl -L "https://github.com/cheat2001/eyebreak/releases/download/v1.0.0/EyeBreak-v1.0.0.dmg" -o "$DMG_PATH"
fi

echo "🔓 Removing quarantine attribute..."
xattr -cr "$DMG_PATH"

echo "📀 Mounting DMG..."
hdiutil attach "$DMG_PATH"

echo ""
echo "✅ Ready to install!"
echo ""
echo "👉 Now drag EyeBreak.app to Applications folder"
echo "   Then run: open /Applications/EyeBreak.app"
echo ""
