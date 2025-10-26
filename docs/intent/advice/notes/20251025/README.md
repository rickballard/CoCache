# AdviceBomb — Contributors & Digital Halos (v0.1)
**Purpose:** Seed a rigorous, opt‑in directory of potential CoCivium contributors and a matching **Digital Halo** schema (claims/attestations/proofs) that can later anchor on‑chain.
**Scope:** Off‑chain now; optional periodic on‑chain anchoring later. Aligns with MeritRank / RepTag / ScripTag primitives.

## Contents
- `run.ps1` — PS7 DO block. Dry‑run by default; writes only with `-Apply`.
- `_hp.manifest.json` — Package metadata.
- `payload/` — Policy docs, JSON templates, examples.
- `notes/` — TLDR, rubric summary, process checklist.
- `out.txt` — Execution status (updated by `run.ps1`).

## Quick Use
1) Unzip into a working folder (or CoCache inbox processing area).
2) **Dry‑run:** `pwsh ./run.ps1`
3) **Apply (writes files):** `pwsh ./run.ps1 -TargetRoot "C:\Users\Chris\Documents\GitHub\CoCivium" -Apply`
4) Commit/PR the generated assets to `main` (or merge promptly).

## IMPORTANT (Visibility & Ops)
- Keep advice bombs visible: **merge to `main` promptly** once validated to avoid “invisible” inbox artifacts on non‑default branches.
- No pay‑to‑play, strict COI disclosure, right‑to‑reply, opt‑in halos.
- Zero side‑effects by default; **explicit `-Apply` required** to write.

## Guardrails
- Public, verifiable facts unless explicit consent.
- Two‑reviewer rule before publishing any halo.
- Time‑decay: re‑review annually or upon material change.
