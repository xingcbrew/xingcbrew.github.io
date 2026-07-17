#!/usr/bin/env python3
"""
build-search-index.py
Run this from Terminal whenever you add a new chapter PDF:
  python3 build-search-index.py

Reads all ICPCG PDF files from ./ispad/, extracts and chunks the text,
and writes ./ispad/search-index.json for the tool to fetch.
"""

import json
import re
import sys
from pathlib import Path

try:
    import pdfplumber
except ImportError:
    sys.exit("pdfplumber not found. Run: pip3 install pdfplumber")

ISPAD_DIR = Path(__file__).parent / "ispad"
OUTPUT    = ISPAD_DIR / "search-index.json"

# Maps filename patterns to chapter metadata
CHAPTER_MAP = {
    "Chapter-2": {"num": "Ch. 2", "title": "Screening, Staging, and Strategies to Preserve Beta-Cell Function"},
    "Chapter-3": {"num": "Ch. 3", "title": "Definition, Epidemiology, and Classification of Diabetes in Children"},
    "Chapter-4": {"num": "Ch. 4", "title": "Phases of Type 1 Diabetes in Children and Adolescents"},
    "Chapter-5": {"num": "Ch. 5", "title": "Hypoglycaemia"},
    "Chapter-6": {"num": "Ch. 6", "title": "Diabetic Ketoacidosis and Hyperglycaemic Hyperosmolar State"},
    "Chapter-7": {"num": "Ch. 7", "title": "Diabetes Technologies"},
    "Chapter-8": {"num": "Ch. 8", "title": "Glycemic Targets"},
    "Chapter-9": {"num": "Ch. 9", "title": "Insulin and Adjunctive Treatments"},
    "Chapter-10": {"num": "Ch. 10", "title": "Type 2 Diabetes"},
    "Chapter-11": {"num": "Ch. 11", "title": "Other Types of Diabetes"},
    "Chapter-12": {"num": "Ch. 12", "title": "Psychological Care"},
    "Chapter-13": {"num": "Ch. 13", "title": "Diabetic Kidney Disease"},
    "Chapter-14": {"num": "Ch. 14", "title": "Diabetes and the Eye"},
    "Chapter-15": {"num": "Ch. 15", "title": "Diabetic Neuropathy"},
    "Chapter-16": {"num": "Ch. 16", "title": "Management of Diabetes in Adolescents"},
}

# Heading patterns — lines that look like section headings
HEADING_RE = re.compile(
    r'^(\d+(\.\d+)*\.?\s+[A-Z].{5,80}|'   # numbered: "3.1 Something"
    r'[A-Z][A-Z\s]{8,60})$'                # ALL CAPS headings
)

MIN_CHUNK_WORDS = 30   # ignore very short fragments
MAX_CHUNK_CHARS = 800  # soft cap — chunks longer than this get split


def detect_chapter(path: Path) -> dict:
    name = path.name
    for key, meta in CHAPTER_MAP.items():
        if key in name:
            return meta
    # Fallback: try to parse chapter number from filename
    m = re.search(r'Chapter-(\d+)', name, re.IGNORECASE)
    if m:
        n = m.group(1)
        return {"num": f"Ch. {n}", "title": f"Chapter {n}"}
    return {"num": "Unknown", "title": path.stem}


def clean(text: str) -> str:
    # Remove hyphenation across lines, collapse whitespace
    text = re.sub(r'-\n', '', text)
    text = re.sub(r'\n+', ' ', text)
    text = re.sub(r'\s{2,}', ' ', text)
    return text.strip()


def is_heading(line: str) -> bool:
    return bool(HEADING_RE.match(line.strip())) and len(line.strip()) < 120


def chunk_page_text(raw: str) -> list:
    """
    Split a page's raw text into (heading, paragraph) pairs.
    Returns list of (current_heading, chunk_text).
    """
    lines = raw.split('\n')
    chunks = []
    current_heading = None
    buffer = []

    def flush():
        text = clean(' '.join(buffer))
        if len(text.split()) >= MIN_CHUNK_WORDS:
            chunks.append((current_heading, text))

    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        if is_heading(stripped):
            flush()
            buffer = []
            current_heading = stripped
        else:
            buffer.append(stripped)
            # Split long buffers to keep chunks manageable
            joined = ' '.join(buffer)
            if len(joined) > MAX_CHUNK_CHARS:
                flush()
                buffer = []

    flush()
    return chunks


def extract_pdf(path: Path) -> list[dict]:
    meta = detect_chapter(path)
    records = []

    with pdfplumber.open(path) as pdf:
        for page_num, page in enumerate(pdf.pages, start=1):
            raw = page.extract_text()
            if not raw:
                continue
            pairs = chunk_page_text(raw)
            for heading, text in pairs:
                records.append({
                    "chapter": meta["num"],
                    "chapter_title": meta["title"],
                    "page": page_num,
                    "heading": heading,
                    "text": text,
                    # pre-build a lowercase search field
                    "_search": (
                        (heading or '') + ' ' + text
                    ).lower()
                })

    print(f"  {meta['num']} ({path.name}): {len(records)} chunks from {page_num} pages")
    return records


def main():
    pdfs = sorted(ISPAD_DIR.glob("*.pdf"))
    if not pdfs:
        sys.exit(f"No PDFs found in {ISPAD_DIR}")

    print(f"Found {len(pdfs)} PDF(s) in {ISPAD_DIR}\n")

    all_chunks = []
    for pdf in pdfs:
        try:
            chunks = extract_pdf(pdf)
            all_chunks.extend(chunks)
        except Exception as e:
            print(f"  WARNING: could not process {pdf.name}: {e}")

    # Remove the private _search field before writing — we'll rebuild it at search time
    # Actually keep it: it makes client-side search faster (no JS lowercase on every keypress)
    OUTPUT.write_text(json.dumps(all_chunks, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f"\nWrote {len(all_chunks)} chunks → {OUTPUT}")
    print("Upload search-index.json to GitHub to make it available to the tool.")


if __name__ == "__main__":
    main()
