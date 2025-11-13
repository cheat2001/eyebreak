#!/bin/bash

# EyeBreak App Icon Generator
# This script generates all required icon sizes from a source image

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SOURCE_IMAGE="$1"
ICON_SET_PATH="$(dirname "$0")/../EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset"

# Check if source image is provided
if [ -z "$SOURCE_IMAGE" ]; then
    echo -e "${RED}Error: No source image provided${NC}"
    echo "Usage: $0 <path-to-source-image.png>"
    echo "Example: $0 ~/Desktop/eyebreak_logo.png"
    exit 1
fi

# Check if source image exists
if [ ! -f "$SOURCE_IMAGE" ]; then
    echo -e "${RED}Error: Source image not found: $SOURCE_IMAGE${NC}"
    exit 1
fi

echo -e "${GREEN}🎨 EyeBreak App Icon Generator${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Source: ${YELLOW}$SOURCE_IMAGE${NC}"
echo -e "Target: ${YELLOW}$ICON_SET_PATH${NC}"
echo ""

# Create icon set directory if it doesn't exist
mkdir -p "$ICON_SET_PATH"

# Array of required sizes for macOS app icons
declare -a sizes=(16 32 64 128 256 512 1024)

# Generate each icon size
for size in "${sizes[@]}"; do
    output_file="$ICON_SET_PATH/AppIcon-${size}.png"
    echo -e "📦 Generating ${YELLOW}${size}x${size}${NC} icon..."
    
    # Use sips to resize the image
    sips -z "$size" "$size" "$SOURCE_IMAGE" --out "$output_file" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo -e "   ✅ Created: AppIcon-${size}.png"
    else
        echo -e "   ${RED}❌ Failed to create AppIcon-${size}.png${NC}"
        exit 1
    fi
done

echo ""
echo -e "${GREEN}✨ Success! All app icons generated${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. Clean your Xcode build folder (⇧⌘K)"
echo "2. Rebuild the app (⌘B)"
echo "3. The new icon should appear!"
echo ""
echo -e "${YELLOW}Note:${NC} If the icon doesn't update immediately:"
echo "  • Delete the app from /Applications"
echo "  • Clean derived data: rm -rf ~/Library/Developer/Xcode/DerivedData"
echo "  • Rebuild and reinstall"
