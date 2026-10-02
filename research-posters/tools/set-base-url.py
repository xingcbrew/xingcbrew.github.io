#!/usr/bin/env python3
"""Change the site's base URL everywhere it appears.

Usage (from the research-posters folder):
    python3 tools/set-base-url.py https://new-domain.example/research-posters/

The current base URL is read from the <link rel="canonical"> tag in index.html,
then replaced in every file that contains it.
"""
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent.parent  # research-posters/
FILES = [
    HERE / "index.html",
    HERE / "sitemap.xml",
    HERE / "README.md",
    HERE / "tools" / "qr-urls.py",
    HERE.parent / "robots.txt",  # must live at the domain root
]

if len(sys.argv) != 2 or not sys.argv[1].startswith("https://"):
    sys.exit(__doc__)

new = sys.argv[1].rstrip("/") + "/"
html = (HERE / "index.html").read_text()
old = re.search(r'<link rel="canonical" href="([^"]+)"', html).group(1)
if old == new:
    sys.exit("Base URL is already " + new)

for f in FILES:
    if not f.exists():
        continue
    text = f.read_text()
    if old in text:
        f.write_text(text.replace(old, new))
        print(f"updated {f.relative_to(HERE.parent)} ({text.count(old)}x)")
print(f"{old} -> {new}")
