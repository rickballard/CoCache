# InSeed Website Session – Transcript (condensed)
- Email routing plan: contact@/feedback@ → Gmail; reply-from ballard@ without exposing it on pages.
- Edits shipped: feedback qualifiers + rates ack + honeypot; robots noarchive on billing; email reveal pill; button system; 3× logo with dark/light; strap unified; Engagement nav isolated to /engagement; whitepaper/survival → Exec Summary; robots/sitemap/404; canonical & OG/Twitter; homepage CTA trio.
- DNS: SPF include:_spf.google.com; DKIM selector google; DMARC _dmarc with ua=mailto:dmarc@inseed.com (create that mailbox/alias/Group).
- Cloudflare: keep HTML dynamic; cache-bust assets; auto-minify/Brotli TBD (plan-dependent).
- Cleanup: deprecated backups noindexed; many cache-bust passes.
- Open items → notes/INTENTIONS (Unfinished).