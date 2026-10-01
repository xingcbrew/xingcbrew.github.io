/* =========================================================
   CONFIG: edit this block to change the brand name, email,
   shop link or template cards. No other file needs to change.
   ========================================================= */
const CONFIG = {
  brandName: "Xing Brew Design Co.",
  email: "xingbrew@gmail.com",
  etsyUrl: "https://www.etsy.com/ca/shop/DoGoodxDesign?section_id=58266976",

  // Template cards, shown in this order. Add or remove objects to add or remove cards.
  // Layout on desktop: the first 3 cards sit in a row of three (portrait frames),
  // every card after that sits in rows of two (landscape frames).
  // color:       cyan | periwinkle | lavender | pink | red | peach
  // image:       a file in assets/
  // orientation: "landscape" for landscape images (default is portrait)
  // url:         optional. Link to the specific Etsy listing; falls back to etsyUrl.
  templates: [
    {
      name: "Classic Sientific Layout",
      url: "https://dogoodxdesign.etsy.com/listing/4554543793",
      size: "A0 portrait",
      software: "PowerPoint + Canva",
      description: "Classic clinical layout with built-in CONSORT flow diagram",
      image: "assets/Blue.jpg",
      color: "cyan",
    },
    {
      name: "#BetterPoster Big Finding",
      url: "https://dogoodxdesign.etsy.com/listing/4496748762",
      size: "A0 portrait",
      software: "PowerPoint + Canva",
      description: "Billboard-style poster to show your main result, huge, front and centre.",
      image: "assets/Teal.jpg",
      color: "cyan",
    },
    {
      name: "Clinical Case Study",
      url: "https://dogoodxdesign.etsy.com/listing/4497281837",
      size: "A0 landscape",
      software: "PowerPoint + Canva",
      description: "Clean, modern layout for STEM or social sciences.",
      image: "assets/Navy.jpg",
      orientation: "landscape",
      color: "cyan",
    },
    {
      name: "Simple, Clear, Modern",
      url: "https://dogoodxdesign.etsy.com/listing/4496426095",
      size: "A0 landscape",
      software: "PowerPoint + Canva",
      description: "Modern clinical billboard-style poster to highlight your key findings.",
      image: "assets/Navy-landscape.jpg",
      orientation: "landscape",
      color: "cyan",
    },
    {
      name: "Eye-catching Poster 2.0",
      url: "https://dogoodxdesign.etsy.com/ca/listing/4586478276/academic-research-poster-editable-canva",
      size: "A0 landscape",
      software: "Canva",
      description: "Bright and vibrant billboard-style poster for all disciplines.",
      image: "assets/Multi-landscape.jpg",
      orientation: "landscape",
      color: "cyan",
    },
  ],

  // Pre-filled "Request a poster" email
  requestSubject: "Poster request",
  requestBody: [
    "Hi Xing,",
    "",
    "I'd like a poster designed. Here are the details:",
    "",
    "Event / conference name:",
    "Poster size (e.g. 36x48 in, A0):",
    "Deadline:",
    "Do you have a draft or abstract? (yes / no; attach if yes):",
    "Anything else I should know:",
    "",
    "Thanks!",
  ].join("\r\n"),
};

/* ========================================================= */

(function () {
  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => [...root.querySelectorAll(sel)];

  // Brand name, email, shop links
  $$("[data-brand]").forEach((el) => (el.textContent = CONFIG.brandName));
  $$("[data-etsy]").forEach((el) => (el.href = CONFIG.etsyUrl));
  $$("[data-email]").forEach((el) => {
    el.href = "mailto:" + CONFIG.email;
    el.setAttribute("aria-label", "Email " + CONFIG.email);
    el.title = CONFIG.email;
  });

  const request = $("#request-link");
  if (request) {
    request.href =
      "mailto:" + CONFIG.email +
      "?subject=" + encodeURIComponent(CONFIG.requestSubject) +
      "&body=" + encodeURIComponent(CONFIG.requestBody);
  }

  // Template cards
  const list = $("#template-list");
  if (list && CONFIG.templates.length) {
    list.replaceChildren(
      ...CONFIG.templates.map((t) => {
        const li = document.createElement("li");
        li.className = "card card--lift template card--" + (t.color || "cyan");

        const img = document.createElement("img");
        img.className = "template__img";
        img.src = t.image;
        const landscape = t.orientation === "landscape";
        img.width = landscape ? 800 : 600;
        img.height = landscape ? 600 : 800;
        img.loading = "lazy";
        img.decoding = "async";
        img.alt = "Preview of the " + t.name.replace(/\s*\[placeholder\]/i, "") + " poster template";

        const h3 = document.createElement("h3");
        h3.textContent = t.name;

        const meta = document.createElement("p");
        meta.className = "template__meta";
        [t.size, t.software].forEach((v) => {
          const s = document.createElement("span");
          s.textContent = v;
          meta.append(s);
        });

        const desc = document.createElement("p");
        desc.className = "template__desc";
        desc.textContent = t.description;

        const a = document.createElement("a");
        a.className = "card__cta";
        a.href = t.url || CONFIG.etsyUrl;
        a.target = "_blank";
        a.rel = "noopener";
        // Screen readers hear "Buy this template: <name> (opens in a new tab)"
        const label = document.createElement("span");
        const hidden = document.createElement("span");
        hidden.className = "visually-hidden";
        hidden.textContent = ": " + t.name + " (opens in a new tab)";
        label.append("Buy this template", hidden);
        const arrow = document.createElement("span");
        arrow.setAttribute("aria-hidden", "true");
        arrow.textContent = "→";
        a.append(label, arrow);

        li.append(img, h3, meta, desc, a);
        return li;
      })
    );
  }

  // Footer year
  const year = $("#year");
  if (year) year.textContent = new Date().getFullYear();
})();
