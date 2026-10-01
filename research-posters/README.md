# research-posters

Single-page site for academic poster templates and a done-for-you poster design service.
Plain HTML, CSS and JS. No framework, no build step.

**Live URL:** https://xingbrew.ca/research-posters/

```
index.html        page content
styles.css        all styles; palette is at the top
script.js         CONFIG block: brand name, email, Etsy link, template cards
assets/           images (placeholders) and favicon
tools/qr-urls.py  prints QR-tagged URLs
```

## Preview locally

```bash
cd research-posters
python3 -m http.server 8000
```

Open http://localhost:8000. Opening `index.html` directly also mostly works, but the local server is closer to how GitHub Pages serves the site.

## Deploy

This folder lives inside the `xingcbrew.github.io` repo, which GitHub Pages publishes on the custom domain `xingbrew.ca` (set by the `CNAME` file at the repo root). To publish changes, commit and push from the repo root:

```bash
cd ~/Documents/xingcbrew.github.io
git pull
git add research-posters
git commit -m "Update research posters site"
git push
```

After a minute or two the changes are live at https://xingbrew.ca/research-posters/. Old `xingcbrew.github.io/research-posters/` links redirect there automatically, keeping any `?utm_source=`.

Every asset path is relative, so the site works under the `/research-posters/` subfolder. The only absolute URLs are the canonical link and Open Graph tags in `<head>`, plus `BASE_URL` in `tools/qr-urls.py`. Update those if the domain ever changes.

## Replace placeholder images

Save your real image over the placeholder, keeping the **same file name**, and the HTML needs no changes. If you use a different format (for example `.jpg` instead of `.svg`), update the file name in `index.html`, or in `script.js` for template images.

| File | Shape | Used for |
|---|---|---|
| `assets/hero-mockup.svg` | 3:4 portrait, 900×1200 | Hero poster mockup |
| `assets/template-1.svg` … `template-3.svg` | 3:4 portrait, 600×800 | Template card previews |
| `assets/sample-1.svg` … `sample-3.svg` | 3:4 portrait, 600×800 | Sample work |
| `assets/sample-4-before.svg`, `sample-4-after.svg` | 3:4 portrait, 600×800 | Before/after pair |
| `assets/headshot.svg` | Square, 400×400 | About photo |
| `assets/og-image.svg` | 1200×630 | Social share preview. **Replace with a PNG or JPG**, since most social sites don't show SVG, then update `og:image` in `index.html` |
| `assets/favicon.svg` | Square | Browser tab icon |

Keep the same aspect ratio, or update the `width`/`height` attributes on the `<img>` so the page doesn't jump while loading. Compress photos before uploading (for example with squoosh.app). Aim for under 200 KB each.

## Replace placeholder text

Search the project for `[placeholder]`, `[to confirm]`, `PLACEHOLDER` and `TO CONFIRM`. Each one marks something to edit. The `[…]` markers are visible on the page, so delete them once the text is final.

- **Brand name** (currently "Xing Brew Design Co."): change `brandName` in `script.js`. Also change the static copies in `index.html` (the `<title>`, `og:site_name`, and elements with `data-brand`) so it shows without JavaScript and in search results. Your personal name ("Hi, I'm Xing" in About, and "Hi Xing," in the request email) is separate and stays as is.
- **Email:** `email` in `script.js`, plus the static `mailto:` links in `index.html`.
- **Organisations "trust line":** in the About section of `index.html`. Remove the `hidden` attribute once you've confirmed you may name them.

## Add a template card

In `script.js`, copy one object inside `CONFIG.templates` and edit it:

```js
{
  name: "Minimal Grid",
  size: "42×56 in",
  software: "PowerPoint",
  description: "Six equal panels for methods-heavy studies.",
  image: "assets/template-4.jpg",
  orientation: "landscape",   // omit for portrait
  color: "peach",   // cyan | periwinkle | lavender | pink | red | peach
  url: "https://www.etsy.com/ca/listing/…",   // optional; defaults to the shop section
},
```

Add the preview image to `assets/`. On desktop, the first 3 cards sit in a row of three with portrait (3:4) image frames. Every card after that sits in rows of two with landscape (4:3) frames. To change that split, edit the `.grid--templates` rules in `styles.css`. Images are scaled to fit their frame and never cropped.

## Analytics (optional, off by default)

Both options below are privacy-friendly, cookie-free, and need no consent banner.

**Plausible** (paid, plausible.io):
1. Add the site in Plausible with the domain `xingbrew.ca`. To see only poster-site visits, filter by the page path `/research-posters/`.
2. In `index.html`, find the `ANALYTICS` comment in `<head>` and move the Plausible `<script>` line out of the comment.

**Umami** (free tier on cloud.umami.is, or self-hosted):
1. Add a website in Umami and copy its Website ID.
2. Move the Umami `<script>` line out of the comment and replace `YOUR-WEBSITE-ID`.

Use only one of the two.

## Tag QR code URLs

Give each printed poster its own URL so analytics can show which one people scanned. Add `utm_source` with a short location name:

```
https://xingbrew.ca/research-posters/?utm_source=uoft-medsci&utm_medium=qr
```

Plausible and Umami both capture `utm_source` automatically. It appears under **Sources** (Plausible) or **UTM** (Umami). The page itself ignores the parameter.

To generate a list:

```bash
python3 tools/qr-urls.py
```

Or pass your own location names:

```bash
python3 tools/qr-urls.py uoft-robarts sickkids-atrium
```

Example output:

```
https://xingbrew.ca/research-posters/?utm_source=uoft-medsci&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=uoft-robarts&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=uoft-dlsph&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=uoft-sgs&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=tgh&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=sickkids&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=mount-sinai&utm_medium=qr
https://xingbrew.ca/research-posters/?utm_source=mars&utm_medium=qr
```

Paste each URL into any QR code generator. Use lowercase, hyphenated names and keep a list of where each poster went. Test-scan every QR code from a printout before putting it up.

## Colours and accessibility

Each card uses three tokens from `styles.css`: `--X-bg` (pastel background), `--X-fg` (headings and large text) and `--X-ink` (a 25% darker shade for body text, small text and buttons). The ink shades are at least 5.1:1 on their card backgrounds, which passes WCAG AA. If you add a colour, check it at webaim.org/resources/contrastchecker.
