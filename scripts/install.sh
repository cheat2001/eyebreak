#!/bin/bash
# EyeBreak Quick Installer
# Downloads and installs the latest version of EyeBreak

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════╗"
echo "║     👁️  EyeBreak Installer  👁️      ║"
echo "║   Your Eyes Deserve a Break!        ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Error: This script is for macOS only${NC}"
    exit 1
fi

# Check macOS version
macos_version=$(sw_vers -productVersion)
macos_major=$(echo "$macos_version" | cut -d. -f1)
if [[ "$macos_major" -lt 14 ]]; then
    echo -e "${YELLOW}⚠️  Warning: EyeBreak requires macOS 14.0 (Sonoma) or later${NC}"
    echo -e "${YELLOW}   You are running macOS $macos_version${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Configuration
REPO="cheat2001/eyebreak"
RELEASE_URL="https://api.github.com/repos/$REPO/releases/latest"
APP_NAME="EyeBreak"
INSTALL_DIR="/Applications"

echo -e "${BLUE}📥 Fetching latest release information...${NC}"

# Get latest release info
if ! command -v curl &> /dev/null; then
    echo -e "${RED}❌ Error: curl is required but not installed${NC}"
    exit 1
fi

# Download release info
release_info=$(curl -s "$RELEASE_URL")
if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Error: Failed to fetch release information${NC}"
    echo -e "${YELLOW}💡 Tip: Check your internet connection or visit:${NC}"
    echo -e "   https://github.com/$REPO/releases"
    exit 1
fi

# Check if release exists
if echo "$release_info" | grep -q '"message": "Not Found"'; then
    echo -e "${RED}❌ Error: No releases found${NC}"
    echo -e "${YELLOW}💡 Tip: Visit https://github.com/$REPO/releases to check available releases${NC}"
    exit 1
fi

# Extract download URL for DMG
dmg_url=$(echo "$release_info" | grep -o "https://github.com/$REPO/releases/download/[^\"]*\.dmg" | head -1)
version=$(echo "$release_info" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')

if [[ -z "$dmg_url" ]]; then
    echo -e "${RED}❌ Error: DMG file not found in latest release${NC}"
    echo -e "${YELLOW}💡 Tip: Visit https://github.com/$REPO/releases to download manually${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found version: $version${NC}"
echo -e "${BLUE}📦 Download URL: $dmg_url${NC}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
DMG_FILE="$TEMP_DIR/$APP_NAME.dmg"

# Download DMG
echo -e "${BLUE}📥 Downloading $APP_NAME...${NC}"
if ! curl -L -# -o "$DMG_FILE" "$dmg_url"; then
    echo -e "${RED}❌ Error: Download failed${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ Download complete${NC}"

# Mount DMG
echo -e "${BLUE}📀 Mounting DMG...${NC}"
MOUNT_POINT=$(hdiutil attach "$DMG_FILE" -nobrowse | grep "/Volumes/" | sed 's/.*\/Volumes/\/Volumes/' | head -1)

if [[ -z "$MOUNT_POINT" ]]; then
    echo -e "${RED}❌ Error: Failed to mount DMG${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ DMG mounted at: $MOUNT_POINT${NC}"

# Check if app exists in the mounted DMG
if [[ ! -d "$MOUNT_POINT/$APP_NAME.app" ]]; then
    echo -e "${RED}❌ Error: $APP_NAME.app not found in DMG${NC}"
    hdiutil detach "$MOUNT_POINT" -quiet
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Check if app is already installed
if [[ -d "$INSTALL_DIR/$APP_NAME.app" ]]; then
    echo -e "${YELLOW}⚠️  $APP_NAME is already installed${NC}"
    read -p "Replace existing installation? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}🗑️  Removing old version...${NC}"
        # Kill existing process
        pkill -9 "$APP_NAME" 2>/dev/null || true
        rm -rf "$INSTALL_DIR/$APP_NAME.app"
        echo -e "${GREEN}✅ Old version removed${NC}"
    else
        echo -e "${YELLOW}Installation cancelled${NC}"
        hdiutil detach "$MOUNT_POINT" -quiet
        rm -rf "$TEMP_DIR"
        exit 0
    fi
fi

# Copy app to Applications
echo -e "${BLUE}📂 Installing to $INSTALL_DIR...${NC}"
if ! cp -R "$MOUNT_POINT/$APP_NAME.app" "$INSTALL_DIR/"; then
    echo -e "${RED}❌ Error: Failed to copy app to Applications${NC}"
    echo -e "${YELLOW}💡 Tip: You may need administrator privileges${NC}"
    hdiutil detach "$MOUNT_POINT" -quiet
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ App installed successfully${NC}"

# Remove quarantine attribute
echo -e "${BLUE}🔓 Removing quarantine attribute...${NC}"
xattr -cr "$INSTALL_DIR/$APP_NAME.app" 2>/dev/null || true
echo -e "${GREEN}✅ Quarantine removed${NC}"

# Cleanup
echo -e "${BLUE}🧹 Cleaning up...${NC}"
hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✅ Cleanup complete${NC}"

# Success message
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     🎉 Installation Complete! 🎉    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}To launch $APP_NAME:${NC}"
echo -e "  1. Open your ${YELLOW}Applications${NC} folder"
echo -e "  2. Find ${YELLOW}$APP_NAME.app${NC}"
echo -e "  3. ${YELLOW}Right-click${NC} and select ${YELLOW}'Open'${NC} (first time only)"
echo -e "  4. Look for the ${YELLOW}eye icon 👁️${NC} in your menu bar"
echo ""
echo -e "${BLUE}Or launch from Terminal:${NC}"
echo -e "  ${YELLOW}open /Applications/$APP_NAME.app${NC}"
echo ""
echo -e "${BLUE}📚 Documentation:${NC} https://github.com/$REPO"
echo -e "${BLUE}🐛 Report Issues:${NC} https://github.com/$REPO/issues"
echo ""
echo -e "${GREEN}Remember: Every 20 minutes, look 20 feet away for 20 seconds! 👁️✨${NC}"
echo ""

# Ask to launch
read -p "Launch EyeBreak now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}🚀 Launching $APP_NAME...${NC}"
    open "$INSTALL_DIR/$APP_NAME.app"
    echo -e "${GREEN}✅ Look for the eye icon 👁️ in your menu bar!${NC}"
fi

echo ""
echo -e "${GREEN}Thank you for using EyeBreak! 🙏${NC}"
