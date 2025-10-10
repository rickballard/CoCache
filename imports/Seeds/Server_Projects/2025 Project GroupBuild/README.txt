
# GroupBuild Icon Bundle

This bundle contains 20 finalized red-shield, blue-symbol icons for use as bullet-style content markers across the GroupBuild website.

## Contents
- 20 PNG icon files (transparent backgrounds, enhanced contrast, black outlines)
- CSS snippets for hover effects
- README documentation (this file)

## Usage Instructions
1. Place icons in a web-accessible folder (e.g., `/assets/icons/`).
2. Reference each image in your HTML using <img> tags or as CSS backgrounds.
3. Include the sample CSS to create visual hover effects.

## Example HTML Usage
```html
<img class="gb-icon gb-icon-empowerment" src="/assets/icons/GB_Icon_Empowerment_Fist.png" alt="Empowerment">
```

## Example CSS Snippets
```css
.gb-icon {
  width: 48px;
  height: 48px;
  transition: transform 0.2s ease-in-out, box-shadow 0.2s;
}

.gb-icon:hover {
  transform: scale(1.1);
  box-shadow: 0 0 12px rgba(255, 50, 50, 0.7);
}

.gb-icon-empowerment:hover {
  animation: pulse 1s infinite alternate;
}

@keyframes pulse {
  from { transform: scale(1); }
  to { transform: scale(1.2); }
}
```

## Tips for Developers
- Adjust `transform` or `filter` to suit dark/light themes.
- Embed additional effects using SVG versions if needed.
- Maintain filename consistency for reuse in content databases.

---

Created by ChatGPT in collaboration with RickBall.
