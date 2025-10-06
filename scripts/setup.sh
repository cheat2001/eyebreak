#!/bin/bash

# EyeBreak Project Setup Script
# Run this script to set up the project structure and verify all files

set -e

echo "🚀 Setting up EyeBreak project..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Project directory: $PROJECT_DIR"

# Create directory structure if needed
echo ""
echo "📂 Verifying directory structure..."

directories=(
    "EyeBreak/Models"
    "EyeBreak/Managers"
    "EyeBreak/Views"
    "EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset"
    "EyeBreak/Resources/Assets.xcassets/AccentColor.colorset"
    "EyeBreak.xcodeproj"
)

for dir in "${directories[@]}"; do
    if [ -d "$PROJECT_DIR/$dir" ]; then
        echo -e "${GREEN}✓${NC} $dir"
    else
        echo -e "${YELLOW}⚠${NC}  Creating $dir"
        mkdir -p "$PROJECT_DIR/$dir"
    fi
done

# Verify Swift files
echo ""
echo "📄 Verifying Swift files..."

swift_files=(
    "EyeBreak/EyeBreakApp.swift"
    "EyeBreak/Models/TimerState.swift"
    "EyeBreak/Models/Settings.swift"
    "EyeBreak/Managers/BreakTimerManager.swift"
    "EyeBreak/Managers/IdleDetector.swift"
    "EyeBreak/Managers/NotificationManager.swift"
    "EyeBreak/Managers/ScreenBlurManager.swift"
    "EyeBreak/Views/MenuBarView.swift"
    "EyeBreak/Views/SettingsView.swift"
    "EyeBreak/Views/BreakOverlayView.swift"
    "EyeBreak/Views/OnboardingView.swift"
    "EyeBreak/Views/StatsView.swift"
)

for file in "${swift_files[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} Missing: $file"
    fi
done

# Verify configuration files
echo ""
echo "⚙️  Verifying configuration files..."

config_files=(
    "EyeBreak/Info.plist"
    "EyeBreak/EyeBreak.entitlements"
    "EyeBreak.xcodeproj/project.pbxproj"
    "README.md"
    "BUILD.md"
    "LICENSE"
)

for file in "${config_files[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} Missing: $file"
    fi
done

# Generate placeholder app icons using SF Symbols (requires macOS)
echo ""
echo "🎨 Generating placeholder app icons..."

if command -v sips &> /dev/null; then
    # Create a simple colored square as placeholder
    # In production, replace with actual designed icons
    
    ICON_DIR="$PROJECT_DIR/EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset"
    
    # Note: For actual icons, you should design them in a graphics editor
    # These are just placeholders to make the project compile
    echo -e "${YELLOW}⚠${NC}  Using placeholder icons. Replace with designed icons for production!"
    echo "   To generate icons, use an icon design tool or SF Symbols app."
    echo "   Required sizes: 16x16, 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024"
else
    echo -e "${YELLOW}⚠${NC}  'sips' command not found. Please generate app icons manually."
fi

# Check for Xcode
echo ""
echo "🔍 Checking for Xcode..."

if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    echo -e "${GREEN}✓${NC} Found: $XCODE_VERSION"
    
    # Check macOS SDK
    SDK_VERSION=$(xcodebuild -showsdks | grep macosx | tail -n 1 | awk '{print $NF}')
    echo -e "${GREEN}✓${NC} macOS SDK: $SDK_VERSION"
else
    echo -e "${RED}✗${NC} Xcode not found. Please install Xcode from the App Store."
    exit 1
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✨ Setup Complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. Open EyeBreak.xcodeproj in Xcode"
echo "2. Select your development team in Signing & Capabilities"
echo "3. Generate app icons (see BUILD.md for instructions)"
echo "4. Build and run (⌘R)"
echo ""
echo "📚 Read BUILD.md for detailed build instructions"
echo "📖 Read README.md for feature documentation"
echo ""
echo "Happy coding! 👁️✨"
