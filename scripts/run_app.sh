#!/bin/bash

# EyeBreak - Quick Run Script
# Builds and runs the app without opening Xcode

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Building EyeBreak...${NC}"

# Build the app
xcodebuild -project EyeBreak.xcodeproj \
  -scheme EyeBreak \
  -configuration Debug \
  build \
  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build succeeded!${NC}"
else
    echo -e "${YELLOW}⚠️  Build may have failed. Trying to run anyway...${NC}"
fi

# Kill any existing instance
killall EyeBreak 2>/dev/null || true
sleep 0.5

echo -e "${BLUE}👁️  Starting EyeBreak...${NC}"
echo ""

# Get the build path
BUILD_PATH="$HOME/Library/Developer/Xcode/DerivedData/EyeBreak-cmlrpdawzgvviwhfqhvjwymdisax/Build/Products/Debug/EyeBreak.app"

# Open the app
open "$BUILD_PATH"

# Wait and verify it's running
sleep 2

if ps aux | grep "EyeBreak.app" | grep -v grep > /dev/null; then
    echo -e "${GREEN}✅ EyeBreak is running!${NC}"
else
    echo -e "${YELLOW}⚠️  App may not be running. Check for errors.${NC}"
fi

echo ""
echo -e "${BLUE}📱 The app is running in ACCESSORY mode:${NC}"
echo "   • No Dock icon (prevents Space/desktop switching)"
echo "   • Look for 👁️ icon in menu bar (top-right corner)"
echo "   • Overlays appear on YOUR CURRENT workspace!"
echo ""
echo -e "${YELLOW}⌨️  Keyboard Shortcuts:${NC}"
echo "   ⌘⇧O - Open Settings"
echo "   ⌘⇧S - Start timer"
echo "   ⌘⇧B - Take break now"
echo "   ⌘⇧X - Stop timer"
echo "   ⌘⇧R - Show test reminder"
echo ""
echo -e "${BLUE}🧪 Test it now:${NC}"
echo "   1. Press ⌘⇧R to show a test reminder"
echo "   2. It should appear on YOUR CURRENT screen"
echo "   3. Press ⌘⇧O to open Settings and configure"
echo ""
echo -e "${GREEN}App is running in background. Use keyboard shortcuts to interact!${NC}"
