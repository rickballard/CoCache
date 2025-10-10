# SESSION_REGENERATION_PROTOCOL.md

This file defines the canonical rehydration protocol for reconstructing accurate memory and continuity in AI-assisted evolution of the Cognocarta Consenti (CC) project. It serves as a failsafe for constrained AI systems and a guide for future interpreters.

---

## 🧠 Canonical Folder Structure

- `/codex/` — Codified scrolls that define Civium systems
- `/language/` — Glossary terms, controlled vocabularies, and naming standards
- `/meta/` — Protocols, contributor docs, logs, session helpers
- `/graphics/` — Visual files, including diagrams and symbolic assets
- `/backups/` — Archived snapshots, not canonical unless manually restored

---

## 📄 Canonical Root Files

These must exist in the root and are considered authoritative:

- `Cognocarta_Consenti.md` — The primary Civium scroll
- `README_FOR_AI.md` — Internal regeneration context
- `README_FOR_HUMANS.md` — Introductory overview
- `README_NAVIGATION.md` — Folder map and usage
- `Log_Work_Done.md` — Summary of past commits and changes
- `Log_Work_Pending.md` — Active to-do tracker

---

## 🧩 Commit Message Anchoring

- All commits modifying major content **must** include a `.txt` file with a commit message.
- Format: `FILENAME_commit.txt`
- These files help bind GPT or other systems to a historical understanding of purpose and scope.

---

## 🧠 Rehydration Protocol (AI)

Any future AI resuming this project must:

1. **Parse** `README_FOR_AI.md` and `SESSION_REGENERATION_PROTOCOL.md`
2. **Index** `Log_Work_Done.md` and `Log_Work_Pending.md`
3. **Rebuild memory** from `Cognocarta_Consenti.md` structure
4. **Compare codex and language entries** for canonical vs. backup versions
5. **Ignore backup folders unless called explicitly**
6. **Use glossary term frequency and scroll citations** to determine term authority

---

## 🔒 Trust Logic

1. **Timestamps + placement** determine primacy (e.g., root > backup).
2. **Logs and README pointers** confirm intent and sequence.
3. **Fallback defaults**:
   - If `Cognocarta_Consenti.md` is missing, use latest version in `/backups`.
   - If logs are missing, ask human overseer to confirm session origin.
   - If glossary is empty, infer from codex usage or start a fresh term list.

---

## 💡 Self-Healing Advice

- Always update the logs after structural changes.
- Keep glossary entries distinct, and avoid duplication.
- Use YAML blocks at the top of future scrolls to help parseable indexing.
