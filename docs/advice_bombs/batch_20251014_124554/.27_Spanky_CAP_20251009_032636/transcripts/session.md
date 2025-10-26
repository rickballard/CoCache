# CoPolitic / CAP — Working Session Transcript (condensed)

> Authored reconstruction capturing intentions, pivots, and outputs.

## Early Intentions
- Publish an *exemplar advocates* logo grid to the CAP homepage via manifest.
- Normalize/convert logos into 160×160 PNG tiles with padding.
- Improve readability; remove legacy blocks.
- Add privacy-first analytics with lead alerts.

## Steps & Pivots
1) **Logo pipeline** — PowerShell + ImageMagick conversion with trim/resize/extent; manifest generation; pruning stray assets.
2) **Homepage** — Inject grid CSS/JS (`exemplar-grid-section`), auto-tone per-tile by sampled luminance.
3) **UX polish** — Remove GitHub/link-farm section; width clamp; 404 and Transparency pages.
4) **Analytics** — Plausible with custom events (Sponsor Page, One-Pager Read, Email Click, Outbound Link) + UTM capture.
5) **Leads** — GitHub Action to email daily only when heuristics indicate intent.
6) **Company enrichment (opt-in)** — Cloudflare Worker (IPinfo / Clearbit) → `Company Revealed` event on sponsor/one-pager views.

## Current
- Grid + polish live; analytics code injected; lead alert workflow committed.
- Worker authored; needs wrangler login + secret + deploy + URL paste.

## Next
- Deploy Worker; verify event flow; tune heuristics with real traffic.

