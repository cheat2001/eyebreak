#!/bin/bash
#
# EyeBreak - Create DMG Installer
# Builds the Release app and packages it as a versioned .dmg
#
# Usage:
#   ./scripts/build_dmg.sh            # version read from Info.plist
#   EYEBREAK_VERSION=2.4.0 ./scripts/build_dmg.sh
#
# Safe to run on any machine and on CI: the build output path is derived from
# an explicit -derivedDataPath rather than Xcode's per-machine DerivedData hash.

set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

INFO_PLIST="EyeBreak/Info.plist"
DERIVED_DATA="$REPO_ROOT/build/DerivedData"
APP_PATH="$DERIVED_DATA/Build/Products/Release/EyeBreak.app"

# Version: explicit env wins, otherwise fall back to the bundle's own value.
VERSION="${EYEBREAK_VERSION:-$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$INFO_PLIST")}"
DMG_NAME="EyeBreak-v${VERSION}.dmg"
DMG_PATH="$REPO_ROOT/$DMG_NAME"

echo -e "${BLUE}🚀 Building EyeBreak ${VERSION} for Release...${NC}"

xcodebuild -project EyeBreak.xcodeproj \
  -scheme EyeBreak \
  -configuration Release \
  -derivedDataPath "$DERIVED_DATA" \
  clean build \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=YES \
  CODE_SIGNING_ALLOWED=YES \
  > build.log 2>&1 || { echo -e "${RED}❌ Build failed! See build.log${NC}"; tail -30 build.log; exit 1; }

echo -e "${GREEN}✅ Build succeeded!${NC}"

if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}❌ App not found at: $APP_PATH${NC}"
    exit 1
fi

# Sparkle refuses to install a bundle whose signature does not validate, so fail
# loudly here rather than shipping an update that every client will reject.
echo -e "${BLUE}🔏 Verifying code signature...${NC}"
if ! codesign --verify --deep --strict "$APP_PATH" 2>&1; then
    echo -e "${RED}❌ Code signature does not validate${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Signature validates${NC}"

echo -e "${BLUE}📦 Creating DMG installer...${NC}"

DMG_TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$DMG_TEMP_DIR"' EXIT
DMG_FINAL_DIR="$DMG_TEMP_DIR/EyeBreak"
mkdir -p "$DMG_FINAL_DIR"

echo -e "${BLUE}📋 Copying app...${NC}"
cp -R "$APP_PATH" "$DMG_FINAL_DIR/"

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

ln -s /Applications "$DMG_FINAL_DIR/Applications"

rm -f "$DMG_PATH"

echo -e "${BLUE}💿 Creating disk image...${NC}"
hdiutil create -volname "EyeBreak" \
  -srcfolder "$DMG_FINAL_DIR" \
  -ov -format UDZO \
  "$DMG_PATH" > /dev/null

DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)

echo ""
echo -e "${GREEN}✅ DMG created successfully!${NC}"
echo -e "${BLUE}📍 Location:${NC} $DMG_PATH"
echo -e "${BLUE}📦 Size:${NC} $DMG_SIZE"
echo ""
echo -e "${GREEN}🎉 Ready to distribute!${NC}"
