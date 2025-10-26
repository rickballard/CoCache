# ISSUEOPS quicksheet

Dispatch smoke:
  gh workflow run smoke.yml --ref YOUR_BRANCH -R OWNER/REPO

Pin shims to current CoCache SHA:
  $sha = (git -C "C:\Users\Chris\Documents\GitHub\CoCache" rev-parse HEAD).Trim()
  $targets = @("InSeed","GroupBuild-website","CoCivium™","CoCivium™-website","CoAgent","GIBindex","CoLaminar","rickballard")
  foreach($r in $targets){
    $wf = "C:\Users\Chris\Documents\GitHub\$r\.github\workflows"
    if(Test-Path $wf){
      foreach($f in @("smoke.yml","safety-gate.yml","self-evolve.yml")){
        $p = Join-Path $wf $f
        if(Test-Path $p){ (Get-Content $p) -replace "@main","@$sha" | Set-Content $p }
      }
    }
  }


