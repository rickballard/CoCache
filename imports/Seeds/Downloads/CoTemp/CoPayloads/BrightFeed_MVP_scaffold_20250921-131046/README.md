
# BrightFeed (MVP scaffold)

**Goal:** A compliant, cross‑platform companion that curates a learning‑first feed, hides junk UI (e.g., Shorts/autoplay/comments), and applies user‑approved changes via official surfaces (APIs, content‑blockers, guided settings).

## Pieces in this scaffold

- `extension/` — Chrome/Edge/Firefox MV3 extension (desktop).  Hides Shorts/comments, reads a simple `policy` from `chrome.storage`, and offers a tiny Options UI.
- `webapp/` — Minimal static page to load a policy JSON and an OPML list (for future RSS ingestion).
- `policy/` — JSON schema + example policy files for Kid/Adult modes.
- `docs/` — MVP spec, security/privacy, and roadmap.
- `scripts/build.ps1` — Helper to pack the extension into a zip.

> This is a starting point for vibe‑coding.  The content script demonstrates selectors and a URL‑observer.  Options page persists a policy.  Webapp shows how OPML/policy would flow.  iOS Safari content‑blocker/web‑extension will be added later in a separate Xcode target.
