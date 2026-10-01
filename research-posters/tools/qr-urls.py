#!/usr/bin/env python3
"""Print QR-code URLs, one per printed poster location.

Usage:
    python3 tools/qr-urls.py                   # prints the example list
    python3 tools/qr-urls.py uoft-robarts sickkids-atrium

Each URL gets ?utm_source=<location>, which Plausible and Umami record
automatically, so you can see which printed poster people scanned.
Paste each URL into any QR generator.
"""
import sys
from urllib.parse import urlencode

BASE_URL = "https://xingcbrew.github.io/research-posters/"

EXAMPLES = [
    "uoft-medsci",        # Medical Sciences Building, UofT
    "uoft-robarts",       # Robarts Library
    "uoft-dlsph",         # Dalla Lana School of Public Health
    "uoft-sgs",           # School of Graduate Studies
    "tgh",                # Toronto General Hospital
    "sickkids",           # SickKids / PGCRL
    "mount-sinai",        # Mount Sinai Hospital
    "mars",               # MaRS Discovery District
]

sources = sys.argv[1:] or EXAMPLES
for src in sources:
    slug = src.strip().lower().replace(" ", "-")
    print(BASE_URL + "?" + urlencode({"utm_source": slug, "utm_medium": "qr"}))
