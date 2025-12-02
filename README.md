# Signal Over Noise - Ghostty Theme

A mid-century modern, retro-futuristic color scheme for [Ghostty](https://ghostty.org) terminal.

![Dark Theme](screenshots/dark.png)
![Light Theme](screenshots/light.png)

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Teal | `#1B9AAA` | Primary accent, links |
| Burnt Orange | `#EF6351` | Cursor, errors, emphasis |
| Cream | `#F7F4EA` | Light background, dark foreground |
| Black | `#1A1A1A` | Dark background, light foreground |
| Sage Green | `#88AB8E` | Success, green |
| Mustard Yellow | `#E5B945` | Warnings, yellow |
| Navy Blue | `#2C3E50` | Selection (dark mode) |

## Installation

### Option 1: Copy to Themes Directory

```bash
# macOS
cp signal-over-noise-dark signal-over-noise-light \
  ~/Library/Application\ Support/com.mitchellh.ghostty/themes/

# Linux
cp signal-over-noise-dark signal-over-noise-light \
  ~/.config/ghostty/themes/
```

### Option 2: Clone and Symlink

```bash
git clone https://github.com/aplaceforallmystuff/ghostty-signal-over-noise.git

# macOS
ln -s $(pwd)/ghostty-signal-over-noise/signal-over-noise-dark \
  ~/Library/Application\ Support/com.mitchellh.ghostty/themes/
ln -s $(pwd)/ghostty-signal-over-noise/signal-over-noise-light \
  ~/Library/Application\ Support/com.mitchellh.ghostty/themes/
```

## Usage

Add to your Ghostty config (`~/.config/ghostty/config` or macOS equivalent):

```
# Use dark theme
theme = signal-over-noise-dark

# Or light theme
theme = signal-over-noise-light
```

### Auto-Switch with System Appearance (macOS)

```
theme = light:signal-over-noise-light,dark:signal-over-noise-dark
```

## About Signal Over Noise

[Signal Over Noise](https://go.signalovernoise.at) is a weekly AI newsletter by Jim Christian, focused on practical AI implementation over hype.

The theme reflects the brand's mid-century modern, retro-futuristic aesthetic.

## License

MIT License - see [LICENSE](LICENSE)

## Author

Jim Christian ([@jimchristian](https://github.com/aplaceforallmystuff))
