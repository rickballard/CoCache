# Build-CoAgent-PlanningDocs.ps1
param([string]$OutDir = (Join-Path $HOME 'Desktop\CoAgent_BusinessPlan'),[switch]$NoZip,[switch]$NoClobber)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Write-Doc([string]$Rel,[string]$Text){
  $p=Join-Path $OutDir $Rel;$d=Split-Path -Parent $p
  if($d -and -not (Test-Path $d)){New-Item -ItemType Directory -Force -Path $d|Out-Null}
  if($NoClobber -and (Test-Path $p)){Write-Host "Exists, skipped: $Rel" -ForegroundColor Yellow;return}
  Set-Content -LiteralPath $p -Value $Text -Encoding UTF8;Write-Host "Wrote: $Rel" -ForegroundColor Green
}
$today=Get-Date;$start=$today.ToString('yyyy-MM-dd');$end=$today.AddDays(21).ToString('yyyy-MM-dd')
$index="# CoAgent Planning Docs Index`n`n- Planning_Readiness_Checklist.md`n- Scope_Freeze_P0.md`n- Governance_Mandate.md`n- Risk_Register.md`n- Queue_Watcher_Spec.md`n- Repo_Mutex_Spec.md`n- Logging_Design.md`n- Rollback_Drill.md`n- Tests/MVP_Test_Plan_P0.md`n- RFCs/`n"
$checklist="# CoAgent - Planning Readiness Checklist`n`nStatus: DRAFT.`n`n## Gates`n- [ ] G1 - RFC-0001 v0.1 public comment window: {s} -> {e}.`n- [ ] G2 - MVP tests pass twice.`n- [ ] G3 - Risk register clean of Sev-1.`n- [ ] G4 - Consent-Lock unchanged.`n- [ ] G5 - Scope freeze P0 items.`n- [ ] G6 - Sandbox drills evidence.`n- [ ] G7 - Docs in place.`n- [ ] G8 - CoTemp-by-default wiring active.`n".format(s=$start,e=$end)
Write-Doc 'DOC_INDEX.md' $index
Write-Doc 'Planning_Readiness_Checklist.md' $checklist
Write-Host ("Done -> {0}" -f $OutDir) -ForegroundColor Cyan
if(-not $NoZip){$zip=Join-Path $HOME 'Downloads\CoAgent_PlanningDocs.zip';if(Test-Path $zip){Remove-Item $zip -Force};Compress-Archive -Path (Join-Path $OutDir '*') -DestinationPath $zip -Force;Write-Host ("Zipped -> {0}" -f $zip) -ForegroundColor Cyan}
