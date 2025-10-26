# BPOE (Best Path of Effort) for seeding

- Default to **automerge (squash)**, **delete branch on merge**, and **rebase/merge commits disabled** — to keep history clean and reduce friction.
- Prefer **upstream** for CI/workflows during rebases/merges via `.gitattributes` patterns like:
  ```gitattributes
  .github/workflows/* merge=theirs
  .github/*            merge=theirs
  ```
- Enable `git rerere` to remember conflict resolutions.
- Keep repos **public** during seeding to allow tooling (PS7, site parsers, CoAgents) to read and scaffold.
