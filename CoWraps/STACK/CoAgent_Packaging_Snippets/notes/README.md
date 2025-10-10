# WinGet packaging (overview)

WinGet uses **multi-file manifests**. A minimal set for a ZIP-based portable package is usually:
- `{PackageIdentifier}.yaml` (version manifest)
- `{PackageIdentifier}.installer.yaml` (installer manifest)
- `{PackageIdentifier}.locale.en-US.yaml` (locale)

Replace placeholders with your values.

## Example (coarsely simplified)

### 1) Version manifest (CoCivium.CoAgent.yaml)
```yaml
PackageIdentifier: CoCivium.CoAgent
PackageVersion: 0.1.0
DefaultLocale: en-US
ManifestType: version
ManifestVersion: 1.6.0
```

### 2) Installer manifest (CoCivium.CoAgent.installer.yaml)
```yaml
PackageIdentifier: CoCivium.CoAgent
PackageVersion: 0.1.0
InstallerType: zip
Installers:
  - Architecture: x64
    InstallerUrl: https://example.com/CoAgent_StarterKit_0.1.0.zip
    InstallerSha256: <FILL_SHA256>
    NestedInstallerType: portable
    NestedInstallerFiles:
      - RelativeFilePath: runtime/CoAgentLauncher.ps1
        PortableCommandAlias: coagent
Commands:
  - coagent
ManifestType: installer
ManifestVersion: 1.6.0
```

### 3) Locale manifest (CoCivium.CoAgent.locale.en-US.yaml)
```yaml
PackageIdentifier: CoCivium.CoAgent
PackageVersion: 0.1.0
PackageName: CoAgent Starter Kit
Publisher: CoCivium
ShortDescription: Local two‑session runtime and tools that pave the way to full CoAgent.
License: MIT
ManifestType: defaultLocale
ManifestVersion: 1.6.0
```

## Notes
- Compute SHA256 for your ZIP: `Get-FileHash .\CoAgent_StarterKit_0.1.0.zip -Algorithm SHA256`.
- Submit manifests via PR to https://github.com/microsoft/winget-pkgs (follow their contribution docs).
