# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-11-08

### Changed
- Both themes rebuilt on the Signal Over Noise style guide of 7 November 2026: ink and cream with one red accent. The teal, sage, mustard, navy and purple palette is retired.
- The light theme is now "Paper": ink on `#F7F4EA` with `#B8412F` as the accent.
- The cursor is the accent colour in both themes.
- ANSI green, yellow, blue, magenta and cyan are shades of cream or ink by design; red carries errors, deletions and directories.

### Added
- `shaders/`: three optional Ghostty shaders (`son-break`, `son-trail`, `son-ink`) that run once on focus or cursor moves and touch only the background.
- `screenshots/` and `scripts/screenshots.py`, which renders them from the theme files.

## [1.0.0] - 2025-12-02

### Added
- Initial release
- Dark theme (`signal-over-noise-dark`)
- Light theme (`signal-over-noise-light`)
- Full 16-color ANSI palette for both themes
- macOS system appearance auto-switching support
