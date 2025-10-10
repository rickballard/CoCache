# Backend Gate How-To
Search your Electron main file (e.g., `electron/main.js` or `electron/main.ts`) for the line that loads `http://127.0.0.1:7681/` and replace it with:

```js
(async () => {
  try {
    await win.loadURL('http://127.0.0.1:7681/');
  } catch (e) {
    const {join} = require('path');
    const {existsSync} = require('fs');
    const local = [
      join(__dirname, 'index.html'),
      join(process.cwd(), 'electron', 'index.html'),
      join(process.cwd(), 'electron', 'public', 'index.html')
    ].find(existsSync);
    if (local) { await win.loadFile(local); } else { throw e; }
  }
})()
```
