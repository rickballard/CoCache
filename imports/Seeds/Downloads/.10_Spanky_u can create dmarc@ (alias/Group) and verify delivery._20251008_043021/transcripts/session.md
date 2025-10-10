# InSeed Website Session — condensed transcript
- Email routing: contact@/feedback@ → Gmail; reply-from rballard@ without exposing it on pages.
- Shipped changes:
  • Feedback page: budget/timing qualifiers, rates acknowledgement, honeypot.
  • Billing page: robots noarchive; added “Discount policy & grants”.
  • Sitewide: email reveal pill (light/dark aware), button system cleanup.
  • Header/Logo: ~3×, dual-mode (dark/light SVG), consistent across pages.
  • Straps unified: “TxO Steward · Week-0 CoAudit · Evidence cadence · Portable artifacts”.
  • Nav: “Engagement” only on /engagement/.
  • Whitepaper/Survival → Exec Summary; /whitepaper/ is a redirect.
  • Footer recentered/opacity; 404.html; sitemap.xml; robots.txt; canonical + OG/Twitter.
  • Homepage CTA trio centered: Start a conversation / See the real problems / See the real solutions.
- DNS email auth: SPF include:_spf.google.com; DKIM selector “google”; DMARC _dmarc with rua=dmarc@inseed.com.
- Cloudflare: HTML dynamic, CSS cached; auto-minify/Brotli attempted, fell back to cache-busting; plan toggles may hide.
- Cleanup: deprecated/backups noindexed; many cache-bust passes.
- Open items captured in notes (Unfinished).