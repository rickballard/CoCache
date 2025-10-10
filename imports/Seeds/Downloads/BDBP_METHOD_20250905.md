# BDBP Method — Business‑Development Business Plan
**Date:** 20250905  
**Purpose:** Define the “BDBP” perspective and how we maintain dual plans (private vs public) across CoModules.

## What is a BDBP?
A **Business‑Development Business Plan (BDBP)** is a market‑ and deal‑oriented plan optimized for:  
- investor clarity (problem → solution → traction → revenue),  
- partner enablement (integration and channel motions), and  
- executive alignment (CEO vision translated into practical BD moves).

## Why BDBP?
If vision is not actively worked with line leaders, it stagnates.  BDBP keeps vision **coevolving** by forcing contact with markets, partners, and pricing experiments while preserving a clear technical backbone.

## Dual‑track Docs
- **Private BDBP (this format):** candid pricing bands, partner targets, risk notes, contingency plays.  
- **Public BP (summary):** safe for broad sharing; no sensitive numbers or partner specifics.

## Repository Convention (recommended)
```
CoModules/
  docs/
    business/
      public/
        CoAgent_BP_Public.md
      private/   (restricted)
        CoAgent_BDBP_Private.md
    methods/
      BDBP_METHOD.md
```
Keep the public summary concise; point to docs for details.  The private BDBP carries GTM levers and risk notes.

## Maintenance Cadence
- Update after each release or major partner discussion.  
- Track deltas in a short CHANGELOG at the top of the private BDBP.  
- Archive superseded versions under `docs/business/private/archive/`.