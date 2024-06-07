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
            placeholder.style.color = 'red';
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

    // Show the download button if there's a name input
    const downloadButton = document.getElementById('downloadButton');
    if (name) {
        downloadButton.style.display = 'inline-block';
    } else {
        downloadButton.style.display = 'none';
    }
}

function checkInput() {
    const name = document.getElementById('nameInput').value;
    const downloadButton = document.getElementById('downloadButton');
    if (name) {
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
    const marginBottom = 50; // Margin below ASL characters
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
    ctx.font = '30px Helvetica'; // Set font size and family
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
