# MDI macOS App Distribution Guide

## Prerequisites

### For Professional Distribution (No Security Warnings)
- Apple Developer Account ($99/year)
- Developer ID Application certificate
- App-specific password for notarization

### For Basic Distribution (Free)
- Nothing required, just the built app

---

## Method 1: Basic Distribution (Free)

### Step 1: Create Distributable Package
```bash
cd build/macos
zip -r MDI-v1.0.0.zip MDI.app
```

### Step 2: Share the ZIP File
- Upload to Google Drive, Dropbox, or GitHub Releases
- Share download link with users

### Step 3: User Installation Instructions
1. Download `MDI-v1.0.0.zip`
2. Double-click to unzip
3. Right-click on `MDI.app` → Select "Open"
4. Click "Open" in the security dialog
5. App launches and is now trusted

**Note:** Users will see this warning the first time:
> "MDI cannot be opened because it is from an unidentified developer"

This is normal for unsigned apps. Right-click → Open bypasses it.

---

## Method 2: Code Signing (Professional - Removes Warnings)

### Prerequisites
1. **Enroll in Apple Developer Program**
   - Visit: https://developer.apple.com/programs/
   - Cost: $99/year
   - Approval: ~24-48 hours

2. **Install Xcode** (already done ✅)

3. **Create Certificates**
   - Open Xcode
   - Xcode → Settings → Accounts
   - Add your Apple ID
   - Manage Certificates → + → "Developer ID Application"

### Step 1: Find Your Developer ID
```bash
security find-identity -v -p codesigning
```

Look for: `Developer ID Application: Your Name (TEAM_ID)`

### Step 2: Sign the App
```bash
cd build/macos

# Sign all frameworks first
codesign --force --deep --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --options runtime \
  MDI.app/Contents/Frameworks/*

# Sign the main app
codesign --force --deep --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --options runtime \
  --entitlements ../../entitlements.plist \
  MDI.app
```

### Step 3: Create Entitlements File
Create `entitlements.plist` in project root:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.network.server</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
</dict>
</plist>
```

### Step 4: Verify Signature
```bash
codesign -v --deep --strict MDI.app
spctl -a -t exec -vv MDI.app
```

Should show: `MDI.app: accepted`

### Step 5: Notarize with Apple

**a) Create App-Specific Password**
- Visit: https://appleid.apple.com
- Sign in → Security → App-Specific Passwords
- Generate password for "Notarization"
- Save it securely

**b) Store Credentials**
```bash
xcrun notarytool store-credentials "MDI-Notarization" \
  --apple-id "your-email@example.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "app-specific-password"
```

**c) Create ZIP for Notarization**
```bash
ditto -c -k --keepParent MDI.app MDI-notarization.zip
```

**d) Submit for Notarization**
```bash
xcrun notarytool submit MDI-notarization.zip \
  --keychain-profile "MDI-Notarization" \
  --wait
```

This takes 5-15 minutes. You'll get an ID like: `abc123-def456-...`

**e) Check Status** (if needed)
```bash
xcrun notarytool info abc123-def456-... \
  --keychain-profile "MDI-Notarization"
```

**f) Staple the Ticket**
```bash
xcrun stapler staple MDI.app
```

**g) Verify Notarization**
```bash
spctl -a -vvv -t install MDI.app
```

Should show: `MDI.app: accepted` and `source=Notarized Developer ID`

### Step 6: Create Final Distribution ZIP
```bash
zip -r MDI-v1.0.0-signed.zip MDI.app
```

---

## Method 3: Create DMG Installer (Most Professional)

### Install create-dmg
```bash
brew install create-dmg
```

### Create DMG
```bash
cd build/macos

create-dmg \
  --volname "MDI Installer" \
  --volicon "../../assets/icon_macos.png" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "MDI.app" 200 190 \
  --hide-extension "MDI.app" \
  --app-drop-link 600 185 \
  "MDI-v1.0.0.dmg" \
  "MDI.app"
```

### Sign the DMG (if you did code signing)
```bash
codesign --sign "Developer ID Application: Your Name" MDI-v1.0.0.dmg
```

### Notarize the DMG (if you did notarization)
```bash
xcrun notarytool submit MDI-v1.0.0.dmg \
  --keychain-profile "MDI-Notarization" \
  --wait

xcrun stapler staple MDI-v1.0.0.dmg
```

---

## Distribution Channels

### GitHub Releases (Recommended for Free/Open Source)
1. Create release on GitHub
2. Upload `MDI-v1.0.0.zip` or `MDI-v1.0.0.dmg`
3. Write release notes
4. Share release URL

### Direct Download
- Host on your website
- Use Dropbox/Google Drive with public link
- Use cloud storage with expiring links for security

### Internal Distribution
- Share via institutional file sharing
- Email (if under 25MB)
- Network drive

---

## User Installation Instructions

### For ZIP Distribution
**File: MDI-Installation-Instructions.txt**
```
MDI Installation Instructions
=============================

1. Download MDI-v1.0.0.zip
2. Double-click the ZIP file to extract
3. Drag MDI.app to your Applications folder (optional)
4. Right-click (or Control-click) on MDI.app
5. Select "Open" from the menu
6. Click "Open" in the security dialog
7. MDI will launch

Note: You only need to do the Right-click → Open process once.
After that, you can double-click normally.

System Requirements:
- macOS 11.0 (Big Sur) or later
- 300 MB free disk space

Support: your-email@example.com
```

### For DMG Distribution
```
MDI Installation Instructions
=============================

1. Download MDI-v1.0.0.dmg
2. Double-click to mount the disk image
3. Drag MDI icon to Applications folder
4. Eject the MDI disk image
5. Open Applications folder and launch MDI

[If code-signed and notarized: No additional steps needed]
[If not signed: Use Right-click → Open for first launch]

System Requirements:
- macOS 11.0 (Big Sur) or later
- 300 MB free disk space

Support: your-email@example.com
```

---

## Automated Build Script with Code Signing

Create `build-and-sign.sh`:

```bash
#!/bin/bash
set -e

VERSION="1.0.0"
DEVELOPER_ID="Developer ID Application: Your Name (TEAM_ID)"

echo "🏗️  Building MDI v$VERSION..."
./build-macos.sh

echo "✍️  Code signing..."
cd build/macos
codesign --force --deep --sign "$DEVELOPER_ID" --options runtime MDI.app

echo "📦 Creating DMG..."
create-dmg \
  --volname "MDI Installer" \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "MDI.app" 200 190 \
  --app-drop-link 600 185 \
  "MDI-v$VERSION.dmg" \
  "MDI.app"

echo "🔒 Signing DMG..."
codesign --sign "$DEVELOPER_ID" "MDI-v$VERSION.dmg"

echo "📤 Notarizing..."
xcrun notarytool submit "MDI-v$VERSION.dmg" \
  --keychain-profile "MDI-Notarization" \
  --wait

echo "✅ Stapling..."
xcrun stapler staple "MDI-v$VERSION.dmg"

echo ""
echo "🎉 Done! Ready to distribute:"
echo "   build/macos/MDI-v$VERSION.dmg"
```

---

## Comparison of Methods

| Method | Cost | Security Warning | Professionalism | Setup Time |
|--------|------|------------------|-----------------|------------|
| Basic ZIP | Free | Yes (first launch) | Basic | 5 minutes |
| Code Signed | $99/year | No | Good | 1-2 hours |
| Signed + Notarized | $99/year | No | Professional | 2-3 hours |
| DMG + Signed + Notarized | $99/year | No | Very Professional | 3-4 hours |

---

## Recommendations by Use Case

### Academic/Internal Use (Grinnell College)
- **Start with:** Basic ZIP distribution
- **Why:** Free, simple, users are tech-savvy enough to bypass warning
- **Upgrade to:** Code signing if budget allows for better UX

### Public Distribution
- **Recommended:** DMG + Code Signing + Notarization
- **Why:** Professional appearance, no security warnings, builds trust

### Beta Testing
- **Use:** Basic ZIP
- **Why:** Fast iterations, testers understand it's in development

### Enterprise/Production
- **Required:** Full signing + notarization + DMG
- **Why:** IT departments often block unsigned apps

---

## Next Steps

1. **Decide on distribution method** based on audience and budget
2. **Create user documentation** (installation instructions, user guide)
3. **Set up distribution channel** (GitHub Releases, website, etc.)
4. **Test installation** on a different Mac to verify process
5. **Gather feedback** and iterate

---

## Troubleshooting

### "App is damaged and can't be opened"
This happens with unsigned apps downloaded from the internet.
```bash
# Remove quarantine attribute
xattr -cr /path/to/MDI.app
```

### Gatekeeper blocking app
```bash
# User can temporarily override
sudo spctl --master-disable  # Disable Gatekeeper (not recommended)
# Or: Right-click → Open (safer)
```

### Code signing fails
- Verify certificate: `security find-identity -v -p codesigning`
- Ensure certificate is valid and not expired
- Try cleaning: `codesign --remove-signature MDI.app` then re-sign

### Notarization rejected
- Check logs: `xcrun notarytool log <submission-id> --keychain-profile "MDI-Notarization"`
- Common issues: Missing entitlements, unsigned dependencies
- Fix and resubmit

---

## Resources

- [Apple Code Signing Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [create-dmg Documentation](https://github.com/create-dmg/create-dmg)
- [Notarization Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

---

## Current Status

✅ App built successfully: `build/macos/MDI.app`  
⏳ Choose distribution method  
⏳ Create distribution package  
⏳ Write user documentation  
⏳ Set up distribution channel
