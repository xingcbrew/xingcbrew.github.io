function generateASL() {
    const name = document.getElementById('nameInput').value.toUpperCase();
    const output = document.getElementById('output');
    output.innerHTML = '';  // Clear previous output

    for (let char of name) {
        if (char >= 'A' && char <= 'Z') {
            const img = document.createElement('img');
            img.src = `asl/${char}.png`;  // Assuming images are named A.png, B.png, etc.
            img.alt = char;
            img.onerror = function() {
                console.error(`Failed to load image for ${char}`);
            };
            output.appendChild(img);
        }
    }
}