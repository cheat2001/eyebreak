#!/bin/bash

# Quick test script to verify the app works before distribution

echo "🧪 Testing EyeBreak Build..."
echo ""

APP_PATH="./Build/Export/EyeBreak.app"

# Check if build exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ Build not found!"
    echo "   Run ./build_release.sh first"
    exit 1
fi

echo "✅ Build found: $APP_PATH"
echo ""

# Check code signature
echo "🔍 Checking code signature..."
codesign -dv "$APP_PATH" 2>&1 | head -5
echo ""

# Check bundle ID
echo "🔍 Checking bundle identifier..."
defaults read "$APP_PATH/Contents/Info.plist" CFBundleIdentifier
echo ""

# Check version
echo "🔍 Checking version..."
defaults read "$APP_PATH/Contents/Info.plist" CFBundleShortVersionString
echo ""

# Check required files
echo "🔍 Checking app structure..."
if [ -f "$APP_PATH/Contents/MacOS/EyeBreak" ]; then
    echo "✅ Executable found"
else
    echo "❌ Executable missing!"
fi

if [ -d "$APP_PATH/Contents/Resources" ]; then
    echo "✅ Resources folder found"
else
    echo "❌ Resources missing!"
fi
echo ""

# Test launch
echo "🚀 Testing app launch..."
echo "   (App will open - please verify it works, then quit)"
open "$APP_PATH"
echo ""
echo "⏳ Waiting 5 seconds..."
sleep 5

# Check if running
if pgrep -x "EyeBreak" > /dev/null; then
    echo "✅ App launched successfully!"
    echo ""
    echo "📋 Manual checks:"
    echo "   1. Does the Settings window appear?"
    echo "   2. Can you enable Ambient Reminders?"
    echo "   3. Press ⌘⇧R - does a reminder appear?"
    echo "   4. Does it make a sound?"
    echo "   5. Can you start the timer with ⌘⇧S?"
    echo ""
    echo "If all checks pass, you're ready to distribute! 🎉"
else
    echo "⚠️  App may not have launched"
    echo "   Check Console.app for crash logs"
fi

echo ""
echo "💡 To create distribution files:"
echo "   ./build_release.sh"
echo ""
echo "📦 Files will be in:"
echo "   - Build/EyeBreak-v1.0.0.dmg (for users)"
echo "   - Build/EyeBreak.zip (for Homebrew)"
