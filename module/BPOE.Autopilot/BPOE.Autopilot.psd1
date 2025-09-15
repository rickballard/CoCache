@{
  RootModule = 'BPOE.Autopilot.psm1'
  ModuleVersion = '0.1.0'
  GUID = 'b01f0e0e-0bee-4b0e-98d4-5d1a9decb0e1'
  Author = 'Rick'
  Description = 'CoCache BPOE Autopilot helpers'
  PowerShellVersion = '7.0'
  FunctionsToExport = @('Invoke-BPOEAssetsManifest','Test-BPOERepoSmoke')
}
