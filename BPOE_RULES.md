# BPOE: Repo Automation Rules

**Rule #1: No PowerShell here-strings** (@" … "@ or @' … '@) in any script, doc-writer, or DO block.
- Use arrays-of-lines + Set-Content instead.
- Reason: sessions/interpreters frequently truncate or leak here-strings.

**Rule #2: DO Blocks must be idempotent** (safe to re-run).

**Rule #3: Keep scripts small and composable** (one narrow task each).

**Rule #4: Commit the hooks folder** so the policy travels with the repo:
  - `.githooks/pre-commit.ps1`, `.githooks/pre-commit.cmd`, `.githooks/pre-commit`
  - `git config core.hooksPath .githooks`

**Rule #5: Prefer HTTPS remotes** for CI/automation unless SSH keys are guaranteed.

