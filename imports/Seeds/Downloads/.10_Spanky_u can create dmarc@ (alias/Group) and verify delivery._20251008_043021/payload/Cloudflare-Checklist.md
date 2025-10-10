# Cloudflare Checklist (Plan-aware)
- CDN in front of GitHub Pages ✔
- Cache HTML: Bypass/standard; CSS/JS: cache with querystring cache-busting ✔
- Auto-minify (HTML/CSS/JS): attempted; if plan hides toggles, fallback = manual or unminified + cache-bust ✔
- Brotli: enable if available; otherwise accept gzip
- Purge Everything after big asset/HTML rewrites (did multiple times)