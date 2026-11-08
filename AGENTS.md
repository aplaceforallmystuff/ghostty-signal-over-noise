# AGENTS.md - ghostty-signal-over-noise

Public Ghostty theme repo for Signal Over Noise (github.com/aplaceforallmystuff/ghostty-signal-over-noise).

## Source of truth
The palette and motion rules come from the Signal Over Noise style guide (DESIGN.md in the site repo, rewritten 2026-11-07): ink #1A1A1A, cream #F7F4EA, one accent (#B8412F on light, #EF6351 on dark, #E58978 for readable red text on dark). Never teal/blue/green/gold, gradients or glow. Motion runs once, in about a second, with no idle loops. The colours match the author's Omarchy themes `signal-over-noise-dark` and `signal-over-noise-paper`, except that ANSI 0 and 7 are adjusted here so black and white text stay visible.

## Structure
```
signal-over-noise-dark     Ghostty theme (dark)
signal-over-noise-light    Ghostty theme (light, "Paper")
shaders/                   son-break, son-trail, son-ink (kept identical to the author's live Ghostty shaders)
screenshots/               rendered by scripts/screenshots.py (headless Chromium) from the theme files
```

## Rules
- Public repo: no private paths, hostnames or internal file names in shader comments or docs.
- Check a shader compiles before committing (glslangValidator behind a Ghostty-style uniform header).
- The README is reader-facing: write it reader-first and run it through the slop/rhythm lint.
- Commits use conventional format (feat, fix, docs, chore...).
- Never push without the author's explicit go-ahead.
