
# BrightFeed — MVP Spec

## Problem
Default recommenders optimize for watch time, not learning.  Parents and self‑learners want a feed that prizes educational value and mental health, across devices, without violating platform rules.

## Non‑goals
- No stealth automation, no password capture, no scraping behind login walls.
- No attempts to rewire the native iOS YouTube app.  iOS = Safari content‑blockers + web‑extensions.

## MVP Goals
- Hide dopamine hooks (Shorts/home/related/comments) locally in the browser.
- Render a "Clean Feed" fed by policy + whitelisted sources (news RSS + YouTube channel feeds).
- Apply allowed changes via official APIs (subscriptions/playlists) with explicit OAuth consent.
- Provide a one‑page Options UI with checkbox "objectives" → policy JSON.
- Compute two grades: **Focus** (long‑form ratio, autoplay avoided) and **Growth** (topic/signal score × completion).

## Surfaces
- Desktop browsers (Chrome/Edge/Firefox) — MV3 extension.
- Web app (static) — policy + OPML upload demo (future: server fetch + scoring).
- Next phases: iOS Safari content‑blocker/web‑extension; Android with browser extensions.

## Data
- Policy JSON (owner goals).  Stored locally; optional household sync later.
- OPML feeds for news/YouTube channel RSS (user controlled).

## Actions
- Local: hide UI; filter tiles shorter than policy.minVideoMinutes.
- API (opt‑in): subscribe/unsubscribe; create "Daily Learn" playlists; add items.

## Privacy & Safety
- OAuth scopes only.  Audit log of proposed/applied changes.  Local data by default.  Export/erase supported.
