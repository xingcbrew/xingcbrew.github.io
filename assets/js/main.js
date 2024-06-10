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
