/*
	Phantom by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

(function($) {

	var	$window = $(window),
		$body = $('body');

	// Breakpoints.
		breakpoints({
			xlarge:   [ '1281px',  '1680px' ],
			large:    [ '981px',   '1280px' ],
			medium:   [ '737px',   '980px'  ],
			small:    [ '481px',   '736px'  ],
			xsmall:   [ '361px',   '480px'  ],
			xxsmall:  [ null,      '360px'  ]
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

						if (event.keyCode == 13
						&&	event.ctrlKey) {

							event.preventDefault();
							event.stopPropagation();

							$(this).blur();

						}

					})
					.on('blur focus', function() {
						$this.val($.trim($this.val()));
					})
					.on('input blur focus --init', function() {

						$wrapper
							.css('height', $this.height());

						$this
							.css('height', 'auto')
							.css('height', $this.prop('scrollHeight') + 'px');

					})
					.on('keyup', function(event) {

						if (event.keyCode == 9)
							$this
								.select();

					})
					.triggerHandler('--init');

				// Fix.
					if (browser.name == 'ie'
					||	browser.mobile)
						$this
							.css('max-height', '10em')
							.css('overflow-y', 'auto');

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
    output.innerHTML = '';  // Clear previous output
    textOutput.innerHTML = ''; // Clear previous text output

    for (let char of name) {
        if (char >= 'A' && char <= 'Z') {
            const img = document.createElement('img');
            img.src = `asl/${char}.png`;  // Assuming images are named A.png, B.png, C.png
            img.alt = char;
            output.appendChild(img);
        } else {
            // Handle case where image for character is not available
            const placeholder = document.createElement('span');
            placeholder.textContent = char;
            placeholder.style.color = 'black';
            output.appendChild(placeholder);
        }
    }

    // Display the name text below the images
    const textElement = document.createElement('div');
    textElement.style.marginTop = '30px';
    textElement.style.fontSize = '30px';
    textElement.style.letterSpacing = '2px';
    textElement.textContent = name;
    textOutput.appendChild(textElement);

  // Show the download button if there's an output
    const downloadButton = document.getElementById('downloadButton');
    if (output.hasChildNodes()) {
        downloadButton.style.display = 'inline-block';
        additionalText.style.display = 'block'; // Show additional text
    } else {
        downloadButton.style.display = 'none';
        additionalText.style.display = 'none'; // Hide additional text if no output
    }
}

function checkInput() {
    const name = document.getElementById('nameInput').value;
    const downloadButton = document.getElementById('downloadButton');
    const output = document.getElementById('output');
    if (output.hasChildNodes()) {
        downloadButton.style.display = 'inline-block';
    } else {
        downloadButton.style.display = 'none';
    }
}

function downloadASLImage() {
    const name = document.getElementById('nameInput').value.toUpperCase();
    const output = document.getElementById('output');
    const images = output.getElementsByTagName('img');
    
    const imgWidth = 140; // same as in CSS
    const imgHeight = 150; // same as in CSS
    const marginBottom = 40; // Margin below ASL characters
    const textHeight = 20; // Height for the text area
    const totalWidth = (imgWidth + 2) * name.length - 2; // Calculate total width minus extra spacing

    const scaleFactor = 2; // Increase resolution by scaling up

    // Create a high-resolution canvas
    const canvas = document.createElement('canvas');
    canvas.width = totalWidth * scaleFactor;
    canvas.height = (imgHeight + marginBottom + textHeight) * scaleFactor;
    const ctx = canvas.getContext('2d');

    ctx.scale(scaleFactor, scaleFactor); // Scale down the canvas to normal size for drawing

    // Draw images on canvas without scaling
    for (let i = 0; i < images.length; i++) {
        ctx.drawImage(images[i], i * (imgWidth + 2), 0, imgWidth, imgHeight);
    }

    // Draw the name centered underneath the images
    ctx.font = '30px Source Sans Pro'; // Set font size and family
    ctx.fillStyle = 'black'; // Set text color
    ctx.textAlign = 'center'; // Center-align the text
    const textY = imgHeight + marginBottom + textHeight / 2; // Calculate Y position for text
    ctx.fillText(name, totalWidth / 2, textY);

    // Create a link to download the high-resolution image
    const link = document.createElement('a');
    link.download = 'asl-name.png';
    link.href = canvas.toDataURL('image/png');
    link.click();
}