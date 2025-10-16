# DO: Scaffold a working copy locally (PowerShell 7)
param(
  [string]$TargetRoot = "$HOME\Downloads\CoCivium_InvestorPack"
)

Write-Host "Scaffolding investor/outreach working copy at: $TargetRoot"
$dirs = @(
  "deck","two_pager","video","datapack\governance","datapack\tech","datapack\legal",
  "datapack\financials","comms\press_notes","comms\hero_images","comms\logos",
  "outreach","risk","faq","compliance","NOTES"
)
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $TargetRoot $d) | Out-Null }

# Copy this package’s editable starters into the working tree (if run from within the zip extraction).
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$packRoot = Split-Path -Parent $here

$copyList = @(
  "README.md","INTENTIONS.md","INDEX.md","LICENSE.txt",
  "deck\CoCivium_10slide_outline.md",
  "two_pager\CoCivium_2pager.md",
  "video\founder_talk_6min_script.md",
  "video\teaser_30sec_script.md",
  "datapack\governance\Governance_Principles.md",
  "datapack\tech\CoSuite_Architecture_Map.md",
  "datapack\legal\Entity_Split_and_IP_Licensing_Template.md",
  "datapack\financials\Budget_Template.csv",
  "datapack\financials\Capital_Plan.md",
  "comms\press_notes\Press_OneLiners.md",
  "comms\hero_images\README.md",
  "outreach\Target_List_Template.csv",
  "outreach\Email_Templates.md",
  "outreach\Funnel_KPIs.csv",
  "risk\Risks_and_Mitigations.md",
  "faq\Investor_FAQ.md",
  "compliance\Regulatory_Notes_ON_CA_US.md",
  "NOTES\Educational_Notes.md"
)

foreach ($rel in $copyList) {
  $src = Join-Path $packRoot $rel
  $dst = Join-Path $TargetRoot $rel
  if (Test-Path $src) {
    Copy-Item -Force -Path $src -Destination $dst
  }
}

# Create a top-level quick index in the working tree
@"
# CoCivium Investor Pack – Working Copy

Edit order:
1) two_pager/CoCivium_2pager.md
2) deck/CoCivium_10slide_outline.md
3) outreach/Target_List_Template.csv
4) outreach/Funnel_KPIs.csv

Weekly ritual: review KPIs, refresh 2‑pager, update data room links, publish milestones.
"@ | Set-Content (Join-Path $TargetRoot "WORKING_INDEX.md")

Write-Host "Done. Open $TargetRoot in your editor."
