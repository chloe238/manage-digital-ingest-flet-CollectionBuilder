# Installing Xcode for macOS Builds

## Current Status

✅ **Xcode Command Line Tools**: Installed at `/Library/Developer/CommandLineTools`  
❌ **Full Xcode**: Not installed (required for `flet build macos`)

## Why Full Xcode is Needed

The Command Line Tools alone are not sufficient for building macOS applications with Flet. You need the full Xcode application which includes:
- `xcodebuild` tool
- macOS SDKs
- iOS/macOS development frameworks
- CocoaPods support

## How to Install Full Xcode

### Method 1: App Store (Easiest)

1. Open the **App Store** app on your Mac
2. Search for **"Xcode"**
3. Click **"Get"** or **"Install"**
4. Wait for installation (Xcode is ~15GB, takes 30-60 minutes)

### Method 2: Direct Download

1. Visit [developer.apple.com/download](https://developer.apple.com/download)
2. Sign in with your Apple ID (free)
3. Download the latest Xcode
4. Move Xcode.app to /Applications/

## After Installing Xcode

Run these commands to configure Xcode:

```bash
# Set Xcode as the active developer directory
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Accept Xcode license
sudo xcodebuild -license accept

# Run first launch
sudo xcodebuild -runFirstLaunch

# Verify installation
xcodebuild -version
```

## Then Build Your macOS App

Once Xcode is installed and configured:

```bash
cd /Users/mcfatem/GitHub/manage-digital-ingest-flet-CollectionBuilder
.venv/bin/flet build macos
```

The built app will be in `build/macos/`.

## Alternative: Continue Using Web Builds

If you don't want to install Xcode (it's quite large), you can continue using web builds which work perfectly with just Command Line Tools:

```bash
.venv/bin/flet build web
```

Web builds are easier, work cross-platform, and your custom MDI icon is already embedded!

## Automatic Installation Script

If you want to automate this, here's a script (requires Xcode to be manually downloaded first):

```bash
#!/bin/bash

# After installing Xcode from App Store, run this script:

echo "Configuring Xcode..."

# Switch to Xcode
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Accept license
sudo xcodebuild -license accept

# First launch
sudo xcodebuild -runFirstLaunch

# Verify
echo -e "\n✅ Xcode configured successfully!"
xcodebuild -version

echo -e "\nYou can now run: .venv/bin/flet build macos"
```

Save this as `configure-xcode.sh`, make it executable with `chmod +x configure-xcode.sh`, and run it after installing Xcode from the App Store.
