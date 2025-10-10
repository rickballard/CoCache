# InSeed Website Session — condensed
- Email routing: contact@/feedback@ → Gmail; reply-from rballard@ not exposed on pages.
- Shipped: feedback qualifiers + rates ack + honeypot; billing noarchive; email reveal pill; button cleanup.
- Header/Logo ≈3× + dark/light SVG; strap unified; Engagement only on /engagement/.
- Whitepaper/Survival → Exec Summary; /whitepaper/ is a redirect.
- Footer recentered; sitemap.xml; robots.txt; 404.html; canonical + OG/Twitter.
- Home CTA trio: Start a conversation / See the real problems / See the real solutions.
- DNS auth: SPF include:_spf.google.com; DKIM selector "google"; DMARC rua=dmarc@inseed.com.
- Cloudflare: HTML dynamic; CSS cache-busted; auto-minify/Brotli when available.
- Deprecated/backups noindexed; multiple cache-bust passes.