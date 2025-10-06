# EyeBreak Build Scripts

This directory contains automation scripts for building, testing, and distributing EyeBreak.

## Available Scripts

### 🔨 build_release.sh
Builds a release version of EyeBreak and creates distribution packages.

```bash
./scripts/build_release.sh
```

**Creates:**
- `Build/Export/EyeBreak.app` - The application bundle
- `Build/EyeBreak-v1.0.0.dmg` - DMG installer for distribution
- `Build/EyeBreak.zip` - Zip archive for Homebrew

### 🧪 test_build.sh
Runs a test build to verify the project compiles correctly.

```bash
./scripts/test_build.sh
```

### 🧹 clean_build.sh
Cleans all build artifacts and derived data.

```bash
./scripts/clean_build.sh
```

### 📦 build_dmg.sh
Creates a DMG installer from an existing app bundle.

```bash
./scripts/build_dmg.sh
```

### 🚀 run_app.sh
Builds and runs the app for testing.

```bash
./scripts/run_app.sh
```

### ⚙️ setup.sh
Initial setup script to verify project structure.

```bash
./scripts/setup.sh
```

### 🎨 generate_placeholder_icons.sh
Generates placeholder app icons (for development).

```bash
./scripts/generate_placeholder_icons.sh
```

## Usage

Make scripts executable (first time only):
```bash
chmod +x scripts/*.sh
```

Then run any script:
```bash
./scripts/[script-name].sh
```

## Requirements

- macOS 14.0+
- Xcode 15.0+
- Xcode Command Line Tools

## Notes

- All scripts should be run from the project root directory
- Scripts automatically handle code signing for development
- For release builds, update version number in `build_release.sh`
