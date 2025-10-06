#!/bin/bash

# EyeBreak - Create DMG Installer
# This script builds the app and creates a .dmg file for distribution

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Building EyeBreak for Release...${NC}"

# Build the Release version
xcodebuild -project EyeBreak.xcodeproj \
  -scheme EyeBreak \
  -configuration Release \
  clean build \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGN_ENTITLEMENTS="" \
  > build.log 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed! Check build.log for details${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build succeeded!${NC}"

# Path to the built app
BUILD_DIR="$HOME/Library/Developer/Xcode/DerivedData/EyeBreak-cmlrpdawzgvviwhfqhvjwymdisax/Build/Products/Release"
APP_NAME="EyeBreak.app"
APP_PATH="$BUILD_DIR/$APP_NAME"

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}❌ App not found at: $APP_PATH${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Creating DMG installer...${NC}"

# Create a temporary directory for DMG contents
DMG_TEMP_DIR="$(mktemp -d)"
DMG_FINAL_DIR="$DMG_TEMP_DIR/EyeBreak"
mkdir -p "$DMG_FINAL_DIR"

# Copy the app to temp directory
echo -e "${BLUE}📋 Copying app...${NC}"
cp -R "$APP_PATH" "$DMG_FINAL_DIR/"

# Create a README file for the DMG
cat > "$DMG_FINAL_DIR/README.txt" << 'EOF'
EyeBreak - Eye Care Reminder App
================================

INSTALLATION:
1. Drag EyeBreak.app to your Applications folder
2. Open Applications folder and double-click EyeBreak
3. If you see a security warning, go to:
   System Settings → Privacy & Security → Allow app

HOW TO USE:
-----------
After launching, EyeBreak runs in the background with no Dock icon.

KEYBOARD SHORTCUTS:
  ⌘⇧O - Open Settings
  ⌘⇧S - Start timer
  ⌘⇧B - Take break now
  ⌘⇧X - Stop timer
  ⌘⇧R - Show test reminder

MENU BAR ICON:
Look for 👁️ icon in your menu bar (top-right corner).
If not visible, use keyboard shortcuts above.

FINDING THE APP:
- Use Spotlight: Press ⌘Space, type "EyeBreak"
- Or use ⌘⇧O to open Settings anytime

FEATURES:
---------
✓ Break reminders appear on YOUR CURRENT workspace
✓ No desktop/Space switching
✓ Customizable break intervals
✓ Ambient reminder popups
✓ Idle detection (pauses when you're away)

TROUBLESHOOTING:
If the app won't open:
1. Right-click EyeBreak.app → Open
2. Click "Open" in the security dialog

For more help: Check the project repository
EOF

# Create a symbolic link to Applications folder in the DMG
ln -s /Applications "$DMG_FINAL_DIR/Applications"

# DMG output name
DMG_NAME="EyeBreak-Installer.dmg"
DMG_PATH="$(pwd)/$DMG_NAME"

# Remove old DMG if exists
if [ -f "$DMG_PATH" ]; then
    rm "$DMG_PATH"
    echo -e "${YELLOW}🗑️  Removed old DMG${NC}"
fi

# Create the DMG
echo -e "${BLUE}💿 Creating disk image...${NC}"
hdiutil create -volname "EyeBreak" \
  -srcfolder "$DMG_FINAL_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH" \
  > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to create DMG${NC}"
    rm -rf "$DMG_TEMP_DIR"
    exit 1
fi

# Cleanup
rm -rf "$DMG_TEMP_DIR"

# Get file size
DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)

echo ""
echo -e "${GREEN}✅ DMG created successfully!${NC}"
echo ""
echo -e "${BLUE}📍 Location:${NC} $DMG_PATH"
echo -e "${BLUE}📦 Size:${NC} $DMG_SIZE"
echo ""
echo -e "${YELLOW}📝 HOW TO INSTALL:${NC}"
echo "  1. Double-click: $DMG_NAME"
echo "  2. Drag EyeBreak to Applications folder"
echo "  3. Eject the disk image"
echo "  4. Open EyeBreak from Applications or Launchpad"
echo ""
echo -e "${GREEN}🎉 Ready to distribute!${NC}"
echo ""
echo -e "${BLUE}💡 TIP:${NC} You can share this DMG file with others."
echo "     They just need to drag it to Applications to install."
