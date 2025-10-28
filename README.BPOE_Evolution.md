# CoCache — BPOE Evolution Pack (20251028_233414Z)

This pack captures recent workflow learnings and ships:

- **CI guard** for DO-block here-strings: `.github/workflows/bpoe-doblock-lint.yml`
- **Local linter** to run before commits: `tools/BPOE/Scan-DoBlocks.ps1`
- **Patience helper** (second dots): `tools/UX/CoPatience.ps1` + `docs/ux/CoPatience.md`
- **BPOE changelog** seed: `docs/bpoe/BPOE_CHANGELOG.md`

## Install (CoSync-safe)
```pwsh
$R = "$HOME\Documents\GitHub\CoCache"
git -C $R switch main; git -C $R pull --ff-only
$PACK = "$HOME\Downloads\CoCache_BPOE_Evolution_20251028_233414Z.zip"
Expand-Archive -Path $PACK -DestinationPath $R -Force

git -C $R switch -c "bpoe/evolution-20251028_233414Z"
git -C $R add .github/workflows/bpoe-doblock-lint.yml tools/BPOE/Scan-DoBlocks.ps1 tools/UX/CoPatience.ps1 docs/ux/CoPatience.md docs/bpoe/BPOE_CHANGELOG.md README.BPOE_Evolution.md
git -C $R commit -m "bpoe: capture DO-block guard + CoPatience helper + BPOE changelog (20251028_233414Z)"
git -C $R push -u origin HEAD
gh -R rickballard/CoCache pr create --title "bpoe: DO-block guard + CoPatience + changelog" --body "Adds CI here-string guard, local scanner, CoPatience helper/doc, and seeds BPOE changelog."
```
