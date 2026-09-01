(function($) {
    var $window = $(window),
        $body = $('body');

    // Breakpoints.
    breakpoints({
        xlarge: ['1281px', '1680px'],
        large: ['981px', '1280px'],
        medium: ['737px', '980px'],
        small: ['481px', '736px'],
        xsmall: ['361px', '480px'],
        xxsmall: [null, '360px']
    });

    // Play initial animations on page load.
    $window.on('load', function() {
        window.setTimeout(function() {
            $body.removeClass('is-preload');
        }, 100);
    });

    // Touch?
    if (browser.mobile)
        $body.addClass('is-touch');

    // Forms.
    var $form = $('form');

    // Auto-resizing textareas.
    $form.find('textarea').each(function() {
        var $this = $(this),
            $wrapper = $('<div class="textarea-wrapper"></div>'),
            $submits = $this.find('input[type="submit"]');

        $this
            .wrap($wrapper)
            .attr('rows', 1)
            .css('overflow', 'hidden')
            .css('resize', 'none')
            .on('keydown', function(event) {
                if (event.keyCode == 13 && event.ctrlKey) {
                    event.preventDefault();
                    event.stopPropagation();
                    $(this).blur();
                }
            })
            .on('blur focus', function() {
                $this.val($.trim($this.val()));
            })
            .on('input blur focus --init', function() {
                $wrapper.css('height', $this.height());
                $this.css('height', 'auto').css('height', $this.prop('scrollHeight') + 'px');
            })
            .on('keyup', function(event) {
                if (event.keyCode == 9)
                    $this.select();
            })
            .triggerHandler('--init');

        // Fix.
        if (browser.name == 'ie' || browser.mobile)
            $this.css('max-height', '10em').css('overflow-y', 'auto');
    });

    // Menu.
    var $menu = $('#menu');

    $menu.wrapInner('<div class="inner"></div>');

    $menu._locked = false;

    $menu._lock = function() {
        if ($menu._locked)
            return false;

        $menu._locked = true;

        window.setTimeout(function() {
            $menu._locked = false;
        }, 350);

        return true;
    };

    $menu._show = function() {
        if ($menu._lock())
            $body.addClass('is-menu-visible');
    };

    $menu._hide = function() {
        if ($menu._lock())
            $body.removeClass('is-menu-visible');
    };

    $menu._toggle = function() {
        if ($menu._lock())
            $body.toggleClass('is-menu-visible');
    };

    $menu
        .appendTo($body)
        .on('click', function(event) {
            event.stopPropagation();
        })
        .on('click', 'a', function(event) {
            var href = $(this).attr('href');

            event.preventDefault();
            event.stopPropagation();

            // Hide.
            $menu._hide();

            // Redirect.
            if (href == '#menu')
                return;

            window.setTimeout(function() {
                window.location.href = href;
            }, 350);
        })
        .append('<a class="close" href="#menu">Close</a>');

    $body
        .on('click', 'a[href="#menu"]', function(event) {
            event.stopPropagation();
            event.preventDefault();

            // Toggle.
            $menu._toggle();
        })
        .on('click', function(event) {
            // Hide.
            $menu._hide();
        })
        .on('keydown', function(event) {
            // Hide on escape.
            if (event.keyCode == 27)
                $menu._hide();
        });

})(jQuery);

function generateASL() {
    const name = document.getElementById('nameInput').value.toUpperCase();
    const output = document.getElementById('output');
    const textOutput = document.getElementById('textOutput');
    const additionalText = document.getElementById('additionalText');
    output.innerHTML = '';  // Clear previous output
    textOutput.innerHTML = ''; // Clear previous text output

    for (let char of name) {
        const container = document.createElement('div');
        container.style.display = 'inline-block';
        container.style.textAlign = 'center';
        container.style.margin = '5px';

        if (char >= 'A' && char <= 'Z') {
            const img = document.createElement('img');
            img.src = `asl/${char}.png`;  // Assuming images are named A.png, B.png, C.png, etc.
            img.alt = char;
            container.appendChild(img);
        } else {
            const placeholder = document.createElement('span');
            placeholder.textContent = char;
            placeholder.style.color = 'black';
            container.appendChild(placeholder);
        }

        const textElement = document.createElement('div');
        textElement.textContent = char;
        textElement.style.marginTop = '5px';
        textElement.style.fontSize = '20px';
        container.appendChild(textElement);

        output.appendChild(container);
    }

    const downloadButton = document.getElementById('downloadButton');
    if (output.hasChildNodes()) {
        downloadButton.style.display = 'inline-block';
        additionalText.style.display = 'block';
    } else {
        downloadButton.style.display = 'none';
        additionalText.style.display = 'none';
    }
}

function checkInput() {
    const output = document.getElementById('output');
    const downloadButton = document.getElementById('downloadButton');
    const additionalText = document.getElementById('additionalText');
    if (output.hasChildNodes()) {
        downloadButton.style.display = 'inline-block';
        additionalText.style.display = 'block';
    } else {
        downloadButton.style.display = 'none';
        additionalText.style.display = 'none';
    }
}

function downloadASLImage() {
    const name = document.getElementById('nameInput').value.toUpperCase();
    const output = document.getElementById('output');
    const images = output.getElementsByTagName('img');

    const imgWidth = 140;
    const imgHeight = 150;
    const textHeight = 20;
    const marginBottom = 40;
    const totalWidth = (imgWidth + 2) * name.length - 2;

    const scaleFactor = 2;

    const canvas = document.createElement('canvas');
    canvas.width = totalWidth * scaleFactor;
    canvas.height = (imgHeight + textHeight + marginBottom) * scaleFactor;
    const ctx = canvas.getContext('2d');

    ctx.scale(scaleFactor, scaleFactor);

    let xPosition = 0;

    for (let i = 0; i < name.length; i++) {
        const char = name[i];
        if (char !== ' ') {
            ctx.drawImage(images[i - name.substring(0, i).split(' ').length + 1], xPosition, 0, imgWidth, imgHeight);
            ctx.font = '20px Source Sans Pro';
            ctx.fillStyle = 'black';
            ctx.textAlign = 'center';
            ctx.fillText(char, xPosition + imgWidth / 2, imgHeight + textHeight);
        }
        xPosition += imgWidth + 2;
    }

    const link = document.createElement('a');
    link.download = 'asl-name.png';
    link.href = canvas.toDataURL('image/png');
    link.click();
}

function generateBraille() {
    const name = document.getElementById('brailleNameInput').value.toUpperCase();
    const output = document.getElementById('brailleOutput');
    const textOutput = document.getElementById('brailleTextOutput');
    const additionalText = document.getElementById('brailleAdditionalText');
    output.innerHTML = '';  // Clear previous output
    textOutput.innerHTML = ''; // Clear previous text output

    for (let char of name) {
        const container = document.createElement('div');
        container.style.display = 'inline-block';
        container.style.textAlign = 'center';
        container.style.margin = '15px';

        if (char >= 'A' && char <= 'Z') {
            const img = document.createElement('img');
            img.src = `braille/${char}.png`;  // Assuming images are named A.png, B.png, C.png, etc.
            img.alt = char;
            container.appendChild(img);
        } else {
            const placeholder = document.createElement('span');
            placeholder.textContent = char;
            placeholder.style.color = 'black';
            container.appendChild(placeholder);
        }

        const textElement = document.createElement('div');
        textElement.textContent = char;
        textElement.style.marginTop = '5px';
        textElement.style.fontSize = '20px';
        container.appendChild(textElement);

        output.appendChild(container);
    }

    const downloadButton = document.getElementById('downloadBrailleButton');
    if (output.hasChildNodes()) {
        downloadButton.style.display = 'inline-block';
        additionalText.style.display = 'block';
    } else {
        downloadButton.style.display = 'none';
        additionalText.style.display = 'none';
    }
}

function checkBrailleInput() {
    const output = document.getElementById('brailleOutput');
    const downloadButton = document.getElementById('downloadBrailleButton');
    const additionalText = document.getElementById('brailleAdditionalText');
    if (output.hasChildNodes()) {
        downloadButton.style.display = 'inline-block';
        additionalText.style.display = 'block';
    } else {
        downloadButton.style.display = 'none';
        additionalText.style.display = 'none';
    }
}

function downloadBrailleImage() {
    const name = document.getElementById('brailleNameInput').value.toUpperCase();
    const output = document.getElementById('brailleOutput');
    const images = output.getElementsByTagName('img');

    const imgWidth = 80;
    const imgHeight = 120;
    const textHeight = 20;
    const marginBottom = 40;
    const imgMargin = 20; // Increase this value to add more space between images
    const totalWidth = (imgWidth + imgMargin) * name.length - imgMargin;

    const scaleFactor = 2;

    const canvas = document.createElement('canvas');
    canvas.width = totalWidth * scaleFactor;
    canvas.height = (imgHeight + textHeight + marginBottom) * scaleFactor;
    const ctx = canvas.getContext('2d');

    ctx.scale(scaleFactor, scaleFactor);

    let xPosition = 0;

    for (let i = 0; i < name.length; i++) {
        const char = name[i];
        if (char !== ' ') {
            ctx.drawImage(images[i - name.substring(0, i).split(' ').length + 1], xPosition, 0, imgWidth, imgHeight);
            ctx.font = '20px Source Sans Pro';
            ctx.fillStyle = 'black';
            ctx.textAlign = 'center';
            ctx.fillText(char, xPosition + imgWidth / 2, imgHeight + textHeight);
        }
        xPosition += imgWidth + imgMargin; // Increment xPosition by imgWidth plus imgMargin
    }

    const link = document.createElement('a');
    link.download = 'braille-name.png';
    link.href = canvas.toDataURL('image/png');
    link.click();
}
// ============================================================
// APPEND this entire block to the bottom of assets/js/main.js
// ============================================================

// --------------- Batch / Class-List ASL Generator ---------------

const _aslCache = {};  // letter → loaded HTMLImageElement

function _loadLetter(char) {
    if (_aslCache[char]) return Promise.resolve(_aslCache[char]);
    return new Promise((resolve, reject) => {
        const img = new Image();
        img.onload = () => { _aslCache[char] = img; resolve(img); };
        img.onerror = () => reject(new Error(`Failed to load asl/${char}.png`));
        img.src = `asl/${char}.png`;
    });
}

// Returns a canvas for a single name, transparent background.
// Matches the dimensions used by downloadASLImage().
async function _renderNameCanvas(name) {
    const upper = name.toUpperCase().trim();
    const letters = [...upper].filter(c => c >= 'A' && c <= 'Z');
    if (letters.length === 0) return null;

    // Pre-load every distinct letter we need
    const unique = [...new Set(letters)];
    const imgs = {};
    await Promise.all(unique.map(async c => { imgs[c] = await _loadLetter(c); }));

    const imgW = 140, imgH = 150, textH = 20, padBottom = 40;
    const gap = 2;
    const scale = 2;

    const canvas = document.createElement('canvas');
    canvas.width  = (imgW + gap) * letters.length * scale;
    canvas.height = (imgH + textH + padBottom) * scale;
    const ctx = canvas.getContext('2d');
    ctx.scale(scale, scale);

    let x = 0;
    for (const char of upper) {
        if (char >= 'A' && char <= 'Z') {
            ctx.drawImage(imgs[char], x, 0, imgW, imgH);
            ctx.font = '20px "Source Sans Pro", sans-serif';
            ctx.fillStyle = 'black';
            ctx.textAlign = 'center';
            ctx.fillText(char, x + imgW / 2, imgH + textH);
            x += imgW + gap;
        }
        // spaces are skipped (no image, no letter advance)
    }
    return canvas;
}

function onClassListInput() {
    // If user clears the textarea, hide the buttons/preview
    const val = document.getElementById('classListInput').value.trim();
    if (!val) {
        document.getElementById('classListPreview').innerHTML = '';
        document.getElementById('classListButtons').style.display = 'none';
        document.getElementById('classListStatus').style.display = 'none';
    }
}

function generateClassList() {
    const raw = document.getElementById('classListInput').value;
    const names = raw.split('\n').map(n => n.trim()).filter(n => n.length > 0);

    const preview  = document.getElementById('classListPreview');
    const buttons  = document.getElementById('classListButtons');
    const status   = document.getElementById('classListStatus');

    preview.innerHTML = '';
    buttons.style.display = 'none';

    if (names.length === 0) {
        status.textContent = 'Please enter at least one name.';
        status.style.display = 'block';
        return;
    }

    status.textContent = `Showing ${names.length} name${names.length > 1 ? 's' : ''}.`;
    status.style.display = 'block';

    names.forEach(name => {
        const upper = name.toUpperCase().trim();

        const card = document.createElement('div');
        card.className = 'batch-card';

        const label = document.createElement('div');
        label.className = 'batch-card-label';
        label.textContent = name;
        card.appendChild(label);

        const row = document.createElement('div');
        row.className = 'batch-card-letters';

        for (const char of upper) {
            if (char < 'A' || char > 'Z') continue;  // skip spaces / symbols
            const slot = document.createElement('div');
            slot.className = 'batch-letter-slot';

            const img = document.createElement('img');
            img.src = `asl/${char}.png`;
            img.alt = char;
            slot.appendChild(img);

            const lbl = document.createElement('span');
            lbl.textContent = char;
            slot.appendChild(lbl);

            row.appendChild(slot);
        }

        card.appendChild(row);
        preview.appendChild(card);
    });

    buttons.style.display = 'block';
}

async function downloadClassListZip() {
    const raw = document.getElementById('classListInput').value;
    const names = raw.split('\n').map(n => n.trim()).filter(n => n.length > 0);
    if (names.length === 0) return;

    const btn = document.getElementById('zipBtn');
    btn.disabled = true;
    btn.textContent = 'Generating ZIP…';

    try {
        const zip = new JSZip();

        for (const name of names) {
            const canvas = await _renderNameCanvas(name);
            if (!canvas) continue;
            const dataUrl = canvas.toDataURL('image/png');
            const b64 = dataUrl.split(',')[1];
            const safe = name.replace(/[^a-zA-Z0-9_-]/g, '_');
            zip.file(`${safe}.png`, b64, { base64: true });
        }

        const blob = await zip.generateAsync({ type: 'blob' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'asl-class-names.zip';
        link.click();
        URL.revokeObjectURL(link.href);
    } catch (err) {
        alert('Error generating ZIP: ' + err.message);
    } finally {
        btn.disabled = false;
        btn.textContent = 'Download as ZIP  (individual transparent PNGs)';
    }
}

async function downloadClassListPDF() {
    const raw = document.getElementById('classListInput').value;
    const names = raw.split('\n').map(n => n.trim()).filter(n => n.length > 0);
    if (names.length === 0) return;

    const btn = document.getElementById('pdfBtn');
    btn.disabled = true;
    btn.textContent = 'Generating PDF…';

    try {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'letter' });

        // Letter: 215.9 × 279.4 mm
        const pageW  = 215.9;
        const pageH  = 279.4;
        const margin = 12;       // page margin (mm)
        const perPage = 4;       // names per page
        const slotH  = (pageH - margin * 2) / perPage;  // ≈ 63.85 mm per slot
        const labelH = 10;       // mm reserved at top of each slot for the name text

        for (let i = 0; i < names.length; i++) {
            const name = names[i];
            const slotIndex = i % perPage;

            if (i > 0 && slotIndex === 0) doc.addPage();

            const canvas = await _renderNameCanvas(name);
            if (!canvas) continue;

            const slotY  = margin + slotIndex * slotH;
            const maxImgW = pageW - margin * 2;
            const maxImgH = slotH - labelH - 4;  // leave 4 mm padding below image

            // Centered, bold name label
            doc.setFont('helvetica', 'bold');
            doc.setFontSize(13);
            doc.setTextColor(40);
            doc.text(name, pageW / 2, slotY + 7, { align: 'center' });

            // Scale ASL image to fit the slot width and height
            const aspect = canvas.width / canvas.height;
            let drawW = maxImgW;
            let drawH = drawW / aspect;
            if (drawH > maxImgH) {
                drawH = maxImgH;
                drawW = drawH * aspect;
            }
            const imgX = (pageW - drawW) / 2;
            doc.addImage(canvas.toDataURL('image/png'), 'PNG', imgX, slotY + labelH, drawW, drawH);

            // Dashed cut line between slots (not after the last name)
            const isLastName   = (i === names.length - 1);
            const isLastOnPage = (slotIndex === perPage - 1);
            if (!isLastName && !isLastOnPage) {
                const cutY = slotY + slotH;
                doc.setDrawColor(180);
                doc.setLineDashPattern([3, 2], 0);
                doc.setLineWidth(0.3);
                doc.line(margin, cutY, pageW - margin, cutY);
                doc.setLineDashPattern([], 0);
            }
        }

        doc.save('asl-class-names.pdf');
    } catch (err) {
        alert('Error generating PDF: ' + err.message);
    } finally {
        btn.disabled = false;
        btn.textContent = 'Download as PDF  (3–4 names per page, cut-out format)';
    }
}
