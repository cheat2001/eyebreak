# App Icon Generation Guide for EyeBreak

## Quick Start

The easiest way to generate app icons is using SF Symbols or designing your own icon.

## Option 1: Using SF Symbols (Recommended for Development)

1. Open the **SF Symbols** app (included with Xcode)
2. Search for "eye" or "eye.fill"
3. Export the symbol as PNG at various sizes
4. Place them in `EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset/`

## Option 2: Design Your Own Icon

### Using Figma, Sketch, or Affinity Designer

1. Create a 1024x1024px artboard
2. Design your icon following Apple's macOS icon guidelines:
   - Use rounded corners (radius ~22.37% of size)
   - Add subtle shadows and depth
   - Keep it simple and recognizable
   - Use the blue color scheme (#007AFF) to match the app

### Recommended Design Elements

- **Main Symbol**: Eye icon (open or stylized)
- **Background**: Gradient from light blue to dark blue
- **Accent**: Small clock or timer element
- **Style**: Modern, minimal, friendly

## Option 3: Use Icon Generator Service

### Online Services (Free)

1. **AppIcon.co** (https://appicon.co)
   - Upload your 1024x1024 design
   - Download all sizes
   - Automatically generates all required sizes

2. **MakeAppIcon** (https://makeappicon.com)
   - Similar to AppIcon.co
   - Generates all platforms including macOS

## Required Icon Sizes for macOS

The app needs these icon sizes:

- 16x16 (1x and 2x = 32x32)
- 32x32 (1x and 2x = 64x64)  
- 128x128 (1x and 2x = 256x256)
- 256x256 (1x and 2x = 512x512)
- 512x512 (1x and 2x = 1024x1024)

## File Naming

Place these files in `EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset/`:

- `AppIcon-16.png` (16x16)
- `AppIcon-32.png` (32x32)
- `AppIcon-64.png` (64x64)
- `AppIcon-128.png` (128x128)
- `AppIcon-256.png` (256x256)
- `AppIcon-512.png` (512x512)
- `AppIcon-1024.png` (1024x1024)

## Using Script to Generate Icons

If you have a 1024x1024 source icon, you can use this script:

```bash
#!/bin/bash

# Icon generator script
SOURCE_ICON="icon-1024.png"  # Your source icon
OUTPUT_DIR="EyeBreak/Resources/Assets.xcassets/AppIcon.appiconset"

# Required sizes for macOS
sizes=(16 32 64 128 256 512 1024)

for size in "${sizes[@]}"; do
    sips -z $size $size "$SOURCE_ICON" --out "$OUTPUT_DIR/AppIcon-$size.png"
    echo "Generated AppIcon-$size.png"
done

echo "✓ All icons generated!"
```

## Quick Temporary Icon (For Development Only)

If you just want to test the app without designing an icon:

```bash
# Generate a simple blue square icon using ImageMagick
convert -size 1024x1024 xc:#007AFF \
    -fill white -pointsize 400 -gravity center -annotate +0+0 "👁️" \
    icon-1024.png

# Then resize to all sizes needed (use script above)
```

Or use the emoji directly in code for the menu bar icon (already implemented in `MenuBarView.swift`).

## Apple's Design Guidelines

Follow these guidelines for a professional icon:

1. **Rounded Corners**: Use 22.37% radius of the icon size
2. **Perspective**: Subtle 3D perspective is acceptable
3. **Gradients**: Smooth gradients work well on macOS
4. **Shadows**: Internal shadows add depth
5. **Contrast**: Ensure good visibility in both light and dark modes
6. **Simplicity**: Icon should be recognizable at 16x16 pixels

## Example Icon Concepts

### Concept 1: Simple Eye
- Blue gradient background
- White stylized eye symbol
- Clean and minimal

### Concept 2: Timer + Eye
- Clock face as background
- Eye in the center
- Represents "watching the time"

### Concept 3: Break Symbol
- Eye with subtle break/pause icon
- Calming color palette
- Represents taking breaks

## Resources

- [Apple Human Interface Guidelines - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [SF Symbols App](https://developer.apple.com/sf-symbols/)
- [macOS Icon Template](https://developer.apple.com/design/resources/)

## Need Help?

If you need a professionally designed icon:
1. Hire a designer on Fiverr or Upwork
2. Use icon template packs
3. Commission custom work from icon designers

For now, the app uses SF Symbols in the menu bar, which works perfectly for a menu bar app!
