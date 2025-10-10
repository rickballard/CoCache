# Cloudflare Checklist
- CDN in front of GitHub Pages ✔
- HTML: standard/bypass; CSS/JS: cache with querystring cache-busting ✔
- Auto-minify + Brotli when available; otherwise rely on cache-busting ✔
- Purge Everything after big rewrites