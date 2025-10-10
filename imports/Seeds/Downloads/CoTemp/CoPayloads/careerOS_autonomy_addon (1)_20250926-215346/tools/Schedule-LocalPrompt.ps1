param(
  [string]$OpenUrl = "https://github.com",
  [string]$Message = "careerOS — quick check-in"
)
Start-Process $OpenUrl
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show($Message, "careerOS", "OK", "Information") | Out-Null
