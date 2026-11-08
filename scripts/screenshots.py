#!/usr/bin/env python3
"""Render screenshots/dark.png and screenshots/light.png from the theme files: a terminal window in the
theme's colours with the son-break focus effect mid-transmission. Needs headless Chromium and a monospace
font (JetBrains Mono if installed). Run from the repo root: python3 scripts/screenshots.py"""
import pathlib, re, subprocess, tempfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
TILE = [(8, 2), (6, 6), (7.5, 3), (5, 8), (8, 2), (6.5, 5), (7.5, 3), (5.5, 7)]
PULSE = "h8l4-7 6 14 6-14 6 14 4-7h8"

def theme(name):
    t = {}
    for line in (ROOT / name).read_text().splitlines():
        m = re.match(r"\s*(palette\s*=\s*(\d+)=|([a-z-]+)\s*=\s*)(#[0-9A-Fa-f]{6})", line)
        if m: t[f"p{m.group(2)}" if m.group(2) else m.group(3)] = m.group(4)
    return t

def section_break(width, noise, signal, opacity):
    mid, bars, left_end, right_start = width / 2, [], 0, width
    x, i = 0, 0
    while x + 2 <= width:
        if abs(x + 1 - mid) >= 33:
            y, h = TILE[i % 8]
            bars.append(f'<rect x="{x}" y="{y}" width="2" height="{h}"/>')
            if x < mid: left_end = x + 2
            elif right_start == width: right_start = x
        x += 5; i += 1
    pm = (left_end + right_start) / 2
    return (f'<svg width="{width*1.5}" height="27" viewBox="0 0 {width} 18"><g fill="{noise}" opacity="{opacity}">{"".join(bars)}</g>'
            f'<path d="M{pm-21} 9{PULSE}" fill="none" stroke="{signal}" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"/></svg>')

def page(t, dark):
    c = lambda n: t[f"p{n}"]
    noise = t["foreground"] if dark else "#9A958B"
    lines = [
        f'<span style="color:{c(9)}">~/Dev/signal-over-noise</span> <span style="color:{c(8)}">main</span>',
        f'<span style="color:{t["foreground"]}">$ ls</span>',
        f'<span style="color:{c(4)};font-weight:700">drafts/</span>  <span style="color:{c(4)};font-weight:700">guides/</span>  README.md  style-guide.md',
        f'<span style="color:{t["foreground"]}">$ git status --short</span>',
        f'<span style="color:{c(2)}">M</span>  drafts/deconstructing-agents.md',
        f'<span style="color:{c(1)}">D</span>  drafts/tech-hype-roundup.md',
        f'<span style="color:{t["foreground"]}">$ npm test</span>',
        f'<span style="color:{c(1)};font-weight:700">✗ 1 failing</span> <span style="color:{c(8)}">· 41 passing</span>',
        f'<span style="color:{c(8)}"># Signal over noise.</span>',
        f'<span style="color:{t["foreground"]}">$ </span><span style="background:{t["cursor-color"]};color:{t["cursor-text"]}">&nbsp;</span>',
    ]
    return f'''<!doctype html><html><head><style>
html,body{{margin:0;background:{t["background"]};}}
.win{{width:1160px;height:620px;box-sizing:border-box;padding:16px 28px;background:{t["background"]};color:{t["foreground"]};
font:22px/1.65 "JetBrainsMono Nerd Font","JetBrains Mono",ui-monospace,monospace;}}
.brk{{display:block;margin:0 -12px 18px;}}
</style></head><body><div class="win"><div class="brk">{section_break(736, noise, t["cursor-color"], .28 if dark else 1)}</div>
{"<br>".join(lines)}</div></body></html>'''

for name, out, dark in (("signal-over-noise-dark", "dark.png", True), ("signal-over-noise-light", "light.png", False)):
    with tempfile.TemporaryDirectory() as d:
        f = pathlib.Path(d) / "s.html"; f.write_text(page(theme(name), dark))
        subprocess.run(["chromium", "--headless=new", "--disable-gpu", "--hide-scrollbars", f"--user-data-dir={d}/p",
                        "--window-size=1160,620", "--force-device-scale-factor=1", f"--screenshot={ROOT/'screenshots'/out}", f.as_uri()],
                       check=True, capture_output=True)
    print("wrote", ROOT / "screenshots" / out)
