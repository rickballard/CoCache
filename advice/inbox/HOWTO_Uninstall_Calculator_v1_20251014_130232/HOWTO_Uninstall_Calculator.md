# Uninstall Windows Calculator

**Per-user**
```powershell
Get-AppxPackage *windowscalculator* | Remove-AppxPackage
```

**All users (admin)**
```powershell
Get-AppxPackage -AllUsers *windowscalculator* | Remove-AppxPackage
```
Reinstall later from Microsoft Store if needed.
