# CollectionBuilder Custom Icon

## Files Created

1. **assets/cb_icon.svg** - Vector SVG version (512x512)
2. **assets/cb_icon.png** - Raster PNG version (512x512, ~7KB)

## Design Elements

The icon features:

- **Blue circular background** (#2563eb) - Represents the digital/tech nature of the application
- **White document/file** - Central element representing metadata and CSV files
  - Folded corner detail for depth
  - Horizontal lines suggesting text/metadata
  - Image placeholder representing digital objects
- **Green "CB" badge** (#10b981) - CollectionBuilder branding in lower right
  - Bold white "CB" text
  - Rounded rectangle background

## Usage in Application

The icon is used in two places:

1. **Window Icon/Favicon** (app.py line ~257)
   ```python
   page.window.icon = "assets/cb_icon.png"
   ```
   - Appears in the window title bar
   - Appears in the taskbar/dock
   - Appears in alt-tab switcher

2. **AppBar Leading Icon** (app.py line ~148)
   ```python
   leading=ft.Container(
       content=ft.Image(src="assets/cb_icon.png", ...)
   )
   ```
   - Appears in the top-left of the application
   - Provides consistent branding

## Technical Details

- **Format**: PNG (RGBA) and SVG
- **Dimensions**: 512x512 pixels
- **Color Profile**: sRGB
- **Transparency**: Yes (RGBA)
- **File Size**: ~7KB (PNG)

## Customization

To customize the icon:

1. **Change colors**: Edit the RGB values in the generation code or SVG
2. **Change badge text**: Modify the "CB" text to any 1-3 character string
3. **Resize**: The PNG can be regenerated at any size by changing the dimensions

## Credits

Created using Python Pillow library with custom drawing commands.
