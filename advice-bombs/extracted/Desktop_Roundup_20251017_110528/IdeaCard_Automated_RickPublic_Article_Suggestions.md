# Idea Card — Automated RickPublic Article Suggestions
**Date:** 2025-09-16  
**Owner:** Rick Ballard  

## Objective
Automate the weekly conversion of trending news, economic, social, AI, and political issues into RickPublic Substack articles, each mapped to CoCivium’s vision and mission. Build credibility as a “truth brand” while driving attention and contributors to CoCivium, and establishing Rick’s public persona for speaking engagements.

---

## Core Principles
- **Best-practice baseline (CoCivium style evolution):** all experiments are measured **between separate articles only** against a stable baseline. No in-article A/B testing.
- **Truth brand over clout:** shock-viral style is acceptable only when sources and methods are transparent.
- **Anti-polarization:** recurring theme of unbiased journalism, resisting indoctrination and monetization-driven media silos.
- **Reader respect:** concise, inference-dense style; meme-able callouts are always anchored to sources.
- **Methods always appended:** each article includes methodology, data sources, and caveats.

---

## Baseline Article Spec
- **Length:** ~800–1100 words (+ appendix).  
- **Structure:**  
  1. Hero infographic (clear data, footnoted sources).  
  2. Lead (≤120 words).  
  3. Three signals (each mapped to a CoCivium soundbite + repo link).  
  4. 1–2 meme-able callouts.  
  5. Reader action/CTA.  
  6. Methods & Sources appendix.  

- **Infographics:** standard chart types (line, bar, slope); avoid dual-axis unless justified.  
- **Callouts:** 100–160 characters, declarative, source-backed.  
- **Links:** stable repo paths, external links with UTM, pinned commits for non-drifting docs.

---

## Weekly Pipeline
1. Ingest curated feeds (economic, social, AI, political).  
2. Normalize & map issues with a **Message Mapper** (neutral summary, canonical CoCivium soundbite, 2–3 repo links, vetted data, infographic type).  
3. Generate hero infographic + alt text.  
4. Draft lead, 3 signals, callouts, CTA.  
5. Append methodology appendix.  
6. Run safety gates: source/license check, bias audit, link lint.  
7. Publish Friday, consistent slot.  
8. Archive artifacts in `/articles/YYYY-WW/` (draft.md, hero.png, methods.md, mapper.json, metrics.csv).

---

## Experiments (Between Articles Only)
- Weeks 1–4: publish pure Baseline to set reference metrics.  
- Weeks 5+: vary **one factor per week** only (topic framing, chart type, callout style, CTA placement, publish time, link count).  
- Promote a winning pattern if ≥ +10 Resonance Score vs baseline for two appearances. Retire if ≤ −10 twice or if unsub rate spikes.

---

## Metrics → Resonance Score
- Open rate  
- Hero dwell (time to scroll)  
- Deep-link CTR (to CoCivium repos)  
- Average read time  
- Share rate (social)  
- Comment quality index (moderated rubric)  
- Subscriber growth  
- Unsub/complaints  

**Resonance Score (0–100):** weighted, normalized over trailing 8 weeks. Logged weekly.

---

## Safety Gates
- **Evidence:** at least 2 independent sources, or one strong dataset + replication note.  
- **Licensing:** all data/visuals license-compliant; attribution included.  
- **Polarization:** no tribal labeling; focus on mechanisms/incentives.  
- **Sensitive issues:** election/health topics require extra review.  
- **Corrections:** visible update log.

---

## Meme-able Callout Seeds
- “Follow the incentives. The story writes itself.”  
- “Measure indoctrination, not outrage.”  
- “Facts are public. Methods are the passport.”  
- “Fix incentives and headlines will follow.”  

---

## Speaking Pipeline
After 10–12 issues with stable Resonance Score > baseline, prepare a one-pager and a 90-second reel to secure invitations for civic-tech, journalism, and AI-governance speaking events.

---

## Next Steps
1. Approve and freeze Baseline spec.  
2. Seed mapper with 6–8 archetypes (inflation, housing, mis/disinfo, AI-regulation, healthcare, platform governance).  
3. Draft and publish Week-1 baseline article.  
4. Begin metrics log.  
5. Plan W5–W12 experiment knobs (one each).  

