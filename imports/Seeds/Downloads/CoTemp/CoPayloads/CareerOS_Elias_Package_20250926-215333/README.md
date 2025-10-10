# Elias CareerOS

A living, versioned operating system for career design, projects, and periodic self‑review.

## What this repository is
- A **source of truth** for roles, skills, projects, and market strategy.
- A place to draft and ship **portfolio projects** aligned with targeted roles.
- A **quarterly check‑in** mechanism (via GitHub Actions) that opens a discussion/issue to reflect and adjust plans.
- An evolving **life‑vision statement** and goals tracker.

## Initial Positioning (high level)
- Strengths: API/back‑end engineering, data modeling, edge/IoT experiments, disciplined problem solving.
- Current market tailwinds: rapid adoption of **AI in existing products**, with needs in **API enablement**, **data pipelines**, **workflow integration**, and **responsible AI**.
- Primary packaging options are documented in `strategy/market-map.md`.

## Using this repo
1. Keep the **master resume** in `profile/resume.md`. Generate tailored resumes from the master by copying role‑specific sections.
2. Track **targets** in `strategy/job-targets.md` and keep **projects** under `projects/` aligned to those targets.
3. Let the quarterly **check‑in workflow** prompt a reflection; capture answers in `reflections/weekly-journal.md` (or open a Discussion).
4. Iterate. When focus changes, document the **pivot** in `strategy/pivot-log.md` with rationale, risks, and next steps.

> This repository is intentionally written to be supportive, forward‑looking, and bias‑toward‑growth in tone. Its aim is to reinforce momentum and clarity while staying honest and evidence‑based.

---

### Structure
```
profile/         # resume, pitch, profile tweaks
strategy/        # options, targets, learning plans, pivot log
projects/        # small, shippable demos supporting the strategy
networking/      # outreach templates, mentor targets, event log
reflections/     # journal + lessons learned
vision/          # life-vision working doc
.github/workflows/quarterly-checkin.yml  # automated prompts
tools/           # helper scripts (profile sync, etc.)
```
