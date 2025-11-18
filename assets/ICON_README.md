# CollectionBuilder + MDI Custom Icons

## Files Created

### Flet Build Icons (for `flet build` command)
1. **assets/icon.png** - Default icon for all platforms (256x256)
2. **assets/icon_macos.png** - macOS-specific icon (256x256)
3. **assets/icon_windows.png** - Windows PNG icon (256x256)
4. **assets/icon_windows.ico** - Windows ICO format (~5KB)
5. **assets/icon_web.png** - Web application icon (256x256)

### Main Application Icon (MDI Icon)
6. **assets/mdi_icon.png** - Main app icon source (256x256) - CollectionBuilder logo with "MDI" badge
7. **assets/favicon-256.png** - High quality favicon (256x256)
8. **assets/favicon-128.png** - Standard favicon (128x128)
9. **assets/favicon-64.png** - Smaller favicon (64x64)
10. **assets/favicon-32.png** - Classic favicon (32x32)
11. **assets/favicon.ico** - Windows ICO format (32x32)

### Original Files
12. **assets/cb-logo-original.png** - Original CollectionBuilder logo from website
13. **assets/cb_icon.svg** - Vector SVG version (512x512) - previous custom icon
14. **assets/cb_icon.png** - Raster PNG version (512x512) - previous custom icon

## Design Elements

The MDI icon features:

- **CollectionBuilder Logo** - Official CB logo from https://collectionbuilder.github.io/
- **Blue "MDI" badge** (#2563eb) - "Manage Digital Ingest" branding in bottom right
  - Bold white "MDI" text
  - Rounded rectangle background
  - Positioned in lower right corner for visibility

## Usage in Application

### During Development (running with `./run.sh` or `flet run`)

The icon is used in two places:

1. **Window Icon/Favicon** (app.py)
   ```python
   page.window.icon = "assets/mdi_icon.png"
   ```
   - Appears in the window title bar
   - Appears in the taskbar/dock
   - Appears in alt-tab switcher

2. **AppBar Leading Icon** (app.py)
   ```python
   leading=ft.Container(
       content=ft.Image(src="assets/mdi_icon.png", ...)
   )
   ```
   - Appears in the top-left of the application
   - Provides consistent branding

### For Production Builds (using `flet build`)

When building standalone executables with `flet build`, the icon system works differently:

- **icon.png** - Default icon used for all platforms
- **icon_macos.png** - macOS application icon (appears in Finder, Dock, etc.)
- **icon_windows.png** / **icon_windows.ico** - Windows executable icon
- **icon_web.png** - Web application icon

The `flet build` command automatically processes these icons and embeds them into the built application. See **BUILD.md** for complete build instructions.

## Technical Details

- **Format**: PNG (RGBA) and ICO
- **Dimensions**: Multiple sizes (32x32 to 256x256)
- **Color Profile**: sRGB
- **Transparency**: Yes (RGBA)
- **File Sizes**: 
  - favicon.ico: ~5KB
  - favicon-32.png: ~2KB
  - favicon-64.png: ~6KB
  - favicon-128.png: ~16KB
  - favicon-256.png: ~31KB
  - mdi_icon.png: ~31KB

## Source

- Original CollectionBuilder logo: https://collectionbuilder.github.io/images/logo/cb-logo-solid-vgold-transparent.png
- License: CollectionBuilder is open source (MIT License)

## Credits

Created using Python Pillow library with the official CollectionBuilder logo and custom "MDI" badge overlay.

