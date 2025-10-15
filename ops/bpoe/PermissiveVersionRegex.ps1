# SEED-ONLY: permissive stamps during bootstrap
# Accept: semver (v?1.2.3), _YYYY-MM-DD_HHMMSS, or _YYYYMMDD_HHmmss
$script:BPOE_PermissiveStamp = '(?ix)
  (v?\d+\.\d+\.\d+(?:[-+][A-Za-z0-9\.-]+)?) |
  (_\d{4}-\d{2}-\d{2}_\d{6}) |
  (_\d{8}_\d{6})
'

