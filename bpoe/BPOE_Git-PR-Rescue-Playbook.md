# BPOE: Git + PowerShell PR Rescue Playbook

## Why pastes keep “leaking”
- Pasting a bypass block at the prompt runs `exit 0` and dumps you to `cmd`.
- Using a here-string inside a doc that shows here-strings can accidentally terminate it.

## Paste-safe patterns
1. Use ALL_CAPS or variables in examples, not <angle> placeholders.
2. Prefer arrays-of-lines over here-strings for large text you paste.
3. When searching for literal markers, prefer -SimpleMatch.
   ```powershell
   $marker = '<!-- DRAFT_LINKS_INSERTED -->'
   if (-not (Select-String -Path $file -SimpleMatch -Pattern $marker -Quiet)) { ... }
   ```
4. Verify the remote branch before creating a PR.
   ```powershell
   git push -u origin $env:BRANCH
   git ls-remote --heads origin $env:BRANCH
   # then:
   gh pr create --base main --head $env:BRANCH --title "…" --body "…"
   ```
5. Put the AB-bypass only inside the hook file, with an interactive-safe guard:
   ```powershell
   $branch = (git rev-parse --abbrev-ref HEAD).Trim()
   if ($branch -match '^(ab/|ab-)') { if ($PSCommandPath) { exit 0 } else { return } }
   ```

## Minimal .gitattributes to reduce CRLF/LF churn
```
* text=auto
*.ps1  text eol=crlf
*.psm1 text eol=crlf
*.md   text eol=lf
*.yml  text eol=lf
```

## Triage when `gh pr create` says “No commits between …”
- Confirm you pushed your branch and that `git log BASE..HEAD` shows commits.
- Confirm `git ls-remote --heads origin YOUR_BRANCH` finds the head.
- Confirm your base branch is the repo default (`git remote show origin`).
<!-- BPOE_PASTE_SAFE_V1 -->
## Paste-safe blocks & hook etiquette

- Keep automation in files; paste only the call to them.
- Use two independent `if` blocks instead of `-and`/`elseif` when pasting at a console.
- Avoid `<placeholders>` in runnable lines; prefer `$VARIABLES` or ALL_CAPS.
- Use `-LiteralPath` for file operations.
- Prefer `-SimpleMatch` for literal marker searches.

### Verify shell & repo before paste
```powershell
if ($PSVersionTable.PSEdition -ne "Core"){ Write-Warning "Start PowerShell 7+: type pwsh" }
(git rev-parse --is-inside-work-tree) | Out-Null
```

<!-- BPOE_CONSOLE_SAFE_V2 -->
## Console-safe automation (lessons learned)
- Keep pre-push bypass logic only in the hook file; never paste it.
- Avoid `<placeholders>` in runnable lines; use `$VARS` or ALL_CAPS.
- Use separate `if` blocks instead of `-and`/`elseif` at the console.
- Search literals with `-SimpleMatch`; file ops use `-LiteralPath`.
- Prefer arrays-of-lines over here-strings when pasting big blocks.

