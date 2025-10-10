Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- settings ---
$Owner='rickballard'; $Repo='CoModules'
$DefaultPath = Join-Path $HOME 'Documents\GitHub\CoModules'

function Ensure-RepoPath {
  if (Test-Path $DefaultPath) { return $DefaultPath }
  $base = Join-Path $HOME 'Documents\GitHub'
  if (-not (Test-Path $base)) { New-Item -ItemType Directory -Force -Path $base | Out-Null }
  Set-Location $base
  try { gh repo view "$Owner/$Repo" > $null 2>&1 } catch { throw "Remote repo $Owner/$Repo not found." }
  git clone "https://github.com/$Owner/$Repo.git" | Out-Null
  return (Join-Path $base $Repo)
}

function Try-SetProtection([int]$Approvals=1,[bool]$RequireCO=$true){
  try {
    $payload = [ordered]@{
      required_status_checks=@{ strict=$false; contexts=@() }
      enforce_admins=$true
      required_pull_request_reviews=@{
        dismiss_stale_reviews=$true
        require_code_owner_reviews=$RequireCO
        required_approving_review_count=$Approvals
      }
      restrictions=$null
      required_linear_history=$true
      allow_force_pushes=$false
      allow_deletions=$false
      block_creations=$false
      required_conversation_resolution=$true
    }
    $tf=New-TemporaryFile
    $payload|ConvertTo-Json -Depth 10|Set-Content -Encoding UTF8 $tf
    gh api --method PUT -H "Accept: application/vnd.github+json" "repos/$Owner/$Repo/branches/main/protection" --input $tf | Out-Null
    Remove-Item $tf -Force
  } catch { Write-Host "(!) Could not adjust branch protection: $($_.Exception.Message)" -ForegroundColor Yellow }
}

# --- run ---
$repo = Ensure-RepoPath
Set-Location $repo
[Environment]::CurrentDirectory = (Get-Location).Path
try { chcp 65001 > $null } catch {}
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
git fetch --prune origin | Out-Null
git switch -C ai-registry/demo-bad-and-badge origin/main | Out-Null

# 1) validator: skip *.bad.json unless STRICT=1
$valPath = "modules/ai-registry/validators/validate.py"
$validator = @'
#!/usr/bin/env python3
import json, sys, glob, os
from jsonschema import Draft202012Validator

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
schema_path = os.path.join(ROOT, "schema", "ai-registry.schema.json")
examples_glob = os.path.join(ROOT, "examples", "*.json")

INCLUDE_BAD = os.getenv("STRICT") == "1"

with open(schema_path, encoding="utf-8") as f:
    schema = json.load(f)

validator = Draft202012Validator(schema)
errors = []
for path in sorted(glob.glob(examples_glob)):
    base = os.path.basename(path)
    if (".bad." in base or base.endswith("-bad.json")) and not INCLUDE_BAD:
        continue
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    errs = sorted(validator.iter_errors(data), key=lambda e: (list(e.path), e.message))
    if errs:
        print(f"❌ {os.path.basename(path)} INVALID")
        for e in errs:
            where = ".".join(str(x) for x in e.path) or "$"
            if where != "$": where = "$."+where
            errors.append(f"{os.path.basename(path)}: {e.message} at {where}")
    else:
        print(f"✅ {os.path.basename(path)} OK")

if errors:
    print("\nFailures:")
    for e in errors:
        print("-", e)
    sys.exit(1)
