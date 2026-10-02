# research-posters

Single-page site for academic poster templates and a done-for-you poster design service.
Plain HTML, CSS and JS. No framework, no build step.

**Live URL:** https://xingbrew.ca/research-posters/

```
index.html              page content, SEO tags, Umami script
styles.css              all styles; palette is at the top
script.js               CONFIG block: brand name, email, Etsy link, template cards
sitemap.xml             sitemap for search engines
assets/                 images and favicon
tools/qr-urls.py        prints QR-tagged URLs
tools/set-base-url.py   changes the site's base URL everywhere
../robots.txt           at the repo root (crawlers only read it there)
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

Every asset path is relative, so the site works under the `/research-posters/` subfolder.

### Base URL

The base URL is **https://xingbrew.ca/research-posters/**. Search engines and link previews need it written out in full, so it appears in several files: the canonical link, Open Graph/Twitter tags and JSON-LD in `index.html`, `sitemap.xml`, `../robots.txt`, `tools/qr-urls.py` and this README. To change it everywhere at once:

```bash
python3 tools/set-base-url.py https://new-domain.example/research-posters/
```

## Images

All images are in `assets/`. To swap one, save the new file under the **same name** and nothing else needs to change. If you use a different name or format, update the path in `index.html`, or in `script.js` for template images.

| File | Size | Used for |
|---|---|---|
| `Multi.jpg` | 1000×1413, portrait | Hero poster image |
| `Blue.jpg` | 1000×1414, portrait | Template card 1: Classic Scientific Layout |
| `Teal.jpg` | 1000×1413, portrait | Template card 2: #BetterPoster Big Finding |
| `Navy.jpg` | 1000×1414, portrait | Template card 3: Clinical Case Study |
| `Navy-landscape.jpg` | 1400×990, landscape | Template card 4: Simple, Clear, Modern |
| `Multi-landscape.jpg` | 1400×990, landscape | Template card 5: Eye-catching and bold |
| `xing.png` | 483×483, square | About photo |
| `og-image.svg` | 1200×630 | Link preview image (Open Graph + Twitter). **Some platforms, including Facebook, LinkedIn, X and iMessage, don't show SVG previews.** Export a 1200×630 PNG or JPG (e.g. `og-image.png`), then update `og:image` and `twitter:image` in `index.html`. |
| `favicon.svg` | square | Browser tab icon |
| `headshot.svg` | square | Unused placeholder. Safe to delete. |

**Web-sized images:** the full-size poster PNGs are 2–4 MB each, too heavy for phones. Make a web copy instead: 1000px wide for portrait or 1400px wide for landscape, saved as JPEG at about 65% quality, which gives around 200 KB each. On a Mac:

```bash
sips -s format jpeg -s formatOptions 65 --resampleWidth 1000 Original.png --out assets/New.jpg
```

Keep your full-size originals outside this folder, so they aren't committed.

## Replace placeholder text

Search the project for `[placeholder]`, `[to confirm]`, `PLACEHOLDER` and `TO CONFIRM` to find anything left to edit. The `[…]` markers show on the page.

- **Brand name** (currently "Xing Brew Design Co."): change `brandName` in `script.js`. Also change the static copies in `index.html` (the `<title>`, `og:site_name`, and elements with `data-brand`) so it shows without JavaScript and in search results. Your personal name ("Hi, I'm Xing" in About, and "Hi Xing," in the request email) is separate and stays as is.
- **Email:** `email` in `script.js`, plus the static `mailto:` links in `index.html`.
- **Organisations "trust line":** in the About section of `index.html`. Only list organisations you have permission to name.

## Add a template card

In `script.js`, copy one object inside `CONFIG.templates` and edit it:

```js
{
  name: "Minimal Grid",
  size: "42×56 in",
  software: "PowerPoint",
  description: "Six equal panels for methods-heavy studies.",
  image: "assets/template-4.jpg",
  orientation: "landscape",   // only for landscape images; leave out for portrait
  color: "peach",   // cyan | periwinkle | lavender | pink | red | peach
  url: "https://www.etsy.com/ca/listing/…",   // optional; defaults to the shop section
},
```

Add the preview image to `assets/` (see "Images" above for sizing).

**Layout:** on desktop, the first 3 cards sit in a row of three with portrait image frames. Every card after that sits in rows of two with landscape frames. Keep portrait templates first and landscape ones after, and set `orientation: "landscape"` on the landscape ones. The current order is 3 portrait, then 2 landscape. To change the split, edit the `.grid--templates` rules in `styles.css`. Images are scaled to fit their frame and never cropped.

Each template card's Etsy link sends an `etsy-click` event to Umami with the template's `name`. If you rename a template, its clicks show under the new name from then on.

## Analytics (Umami Cloud)

The site uses [Umami Cloud](https://cloud.umami.is). It sets no cookies and collects no personal data, so no cookie banner is needed. The footer says so.

<!-- UMAMI WEBSITE ID: 54f23134-623e-4910-9ac0-b61ccb65dc2d
     It's set in index.html <head>, on the cloud.umami.is script tag (data-website-id). Change it there. -->
**Website ID:** `54f23134-623e-4910-9ac0-b61ccb65dc2d`, set on the `cloud.umami.is` script tag in `<head>` of `index.html`.

### Custom events

Clicks are tracked with `data-umami-event` attributes. No personal data is recorded.

| Event | Where | Extra properties |
|---|---|---|
| `etsy-click` | Every Etsy link | `location`: `template-card`, `shop-more-button`, `footer`, `no-js-fallback`. Template cards also send `template` (the template name). |
| `request-poster` | "Request a poster" email button | |
| `request-rush` | "Email me for pricing" rush link | |
| `hero-browse-templates` | Hero "Browse templates" button | |
| `hero-get-poster` | Hero "Get a poster made for you" button | |

Template card events are set in `script.js` (search for `umamiEvent`). The others are attributes in `index.html`. To track another link, add `data-umami-event="your-event-name"` to it.

### Reading the data

In Umami, open the website from the dashboard. Menu names shift a little between Umami versions.

- **Visits from each QR code:** QR URLs carry `?utm_source=…` (see below). Open the **UTM** report (under Reports), or the **Sources**/**Query parameters** panel on the website page. Each printed location appears as its own `utm_source` value.
- **Clicks:** the **Events** panel lists each event by name with counts. Click `etsy-click` to break it down by `template` or `location` and see which template gets clicked most.
- **Pages:** this site and your homepage share the domain. To see only this site, filter by the page path `/research-posters/`.

## Search engines

### Verify the site in Google Search Console

1. Go to https://search.google.com/search-console and click **Add property**.
2. Choose **URL prefix** and enter `https://xingbrew.ca/`. This covers the whole domain, including this folder.
3. Pick a verification method:
   - **HTML tag** (easiest): Google gives you a `<meta name="google-site-verification" …>` tag. Paste it into the `<head>` of the **homepage** (`../index.html`), push, then click **Verify**.
   - **Domain** property instead: verify with a DNS TXT record at your domain registrar (whc.ca). This covers every subdomain too.
4. Leave the verification tag in place afterwards, or Google will un-verify the site.

### Submit the sitemap

1. In Search Console, open **Sitemaps** in the left menu.
2. Enter `https://xingbrew.ca/research-posters/sitemap.xml` and click **Submit**.
3. Status should show **Success** within a day or so. Check **Pages** over the next few weeks to see when the page is indexed.

`robots.txt` lives at the **repo root** (`../robots.txt`), because crawlers only read it from the root of the domain. It allows everything and points to the sitemap. If you edit the page a lot, update `<lastmod>` in `sitemap.xml`.

## Tag QR code URLs

Give each printed poster its own URL so analytics can show which one people scanned. Add `utm_source` with a short location name:

```
https://xingbrew.ca/research-posters/?utm_source=uoft-medsci&utm_medium=qr
```

Umami captures `utm_source` automatically (see "Reading the data" above). The page itself ignores the parameter.

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
