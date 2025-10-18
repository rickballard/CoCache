# CoSuite Metrics & Watchers Index

> ### How to read this page

> **Jump to:** [Metrics (from registry)](#metrics-from-registry) · [Heartbeats & CoPingPong](#heartbeats--copingpong) · [Launchers & Jobs](#launchers--jobs-workflows--scripts) · [Notes](#notes)
> - **Metrics table**: each row is a metric/watcher.
>   - **status** = health badge (green/amber/red/gray).
>   - **id** = metric name.
>   - **cadence** = expected run frequency.
>   - **latest ts / latest fields** = most recent reading.
>   - **history** = CSV timeline for analysis; **log** = latest job/heartbeat log.
> - **Heartbeats & CoPingPong**: quick liveness check; newest timestamps should keep moving.
> - **Launchers & Jobs**:
>   - **Workflows** run in GitHub Actions.
>   - **Scripts** run locally; paths are shown for fast navigation.
>
> **Legend**
> - ![](assets/brand/cocivium_logo_green_tm.svg) = healthy ·
>   ![](assets/brand/cocivium_logo_amber_tm.svg) = attention ·
>   ![](assets/brand/cocivium_logo_red_tm.svg) = failing ·
>   ![](assets/brand/cocivium_logo_gray_tm.svg) = unknown
>
> **Tips**
> - Click a **history** link to download the CSV; open in Excel/Sheets for trends.
> - Click a **log** to see the last run details/errors.
> - Not seeing a metric? Add it to metrics/registry.json, then regenerate.
# CoSuite Metrics & Watchers Index

_Generated: 2025-10-17 20:51:36Z_

## Metrics (from registry)
| status | id | cadence | latest ts | latest fields | history | log |
|---|---|---|---|---|---|---|
| ![](assets/brand/cocivium_logo_gray_tm.svg) | heartbeat.core | on-demand |  |  | [metrics/history/heartbeat.core.csv](metrics/history/heartbeat.core.csv) | [docs/HEARTBEATS/heartbeat.log](docs/HEARTBEATS/heartbeat.log) |
| ![](assets/brand/cocivium_logo_gray_tm.svg) | git.sanity.cocache | on-demand |  |  | [metrics/history/git.sanity.cocache.csv](metrics/history/git.sanity.cocache.csv) | [docs/HEARTBEATS/git_cocache.log](docs/HEARTBEATS/git_cocache.log) |
| ![](assets/brand/cocivium_logo_gray_tm.svg) | git.sanity.inseed | on-demand |  |  | [metrics/history/git.sanity.inseed.csv](metrics/history/git.sanity.inseed.csv) | [../InSeed/docs/HEARTBEATS/git_inseed.log](../InSeed/docs/HEARTBEATS/git_inseed.log) |

## Heartbeats & CoPingPong
- docs/HEARTBEATS/copings.log (size: 0.2 KB, last: 2025-10-17T17:28:19Z)
- docs/HEARTBEATS/git_cocache.log (size: 0.1 KB, last: 2025-10-17T18:26:35Z)
- docs/HEARTBEATS/git_inseed.log (size: 0.1 KB, last: 2025-10-17T18:26:35Z)
- docs/HEARTBEATS/heartbeat.log (size: 0.3 KB, last: 2025-10-17T17:28:17Z)

## Launchers & Jobs (workflows + scripts)

### CoCache
- Workflows:
  - actionlint — .github/workflows/actionlint.yml
  - auto-add-to-project — .github/workflows/auto-add-to-project.yml
  - bpoe-safety-gate — .github/workflows/bpoe-safety-gate.yml
  - bpoe-sanity — .github/workflows/bpoe-sanity.yml
  - bpoe-self-evolve — .github/workflows/bpoe-self-evolve.yml
  - bpoe-smoke — .github/workflows/bpoe-smoke.yml
  - civium-safety — .github/workflows/civium-safety.yml
  - coindex — .github/workflows/coindex.yml
  - congruence — .github/workflows/congruence.yml
  - hygiene — .github/workflows/hygiene.yml
  - initiatives-scan — .github/workflows/initiatives-scan.yml
  - intake-validate — .github/workflows/intake-validate.yml
  - metrics-daily — .github/workflows/metrics-daily.yml
  - metrics-harvest — .github/workflows/metrics-harvest.yml
  - oe-status — .github/workflows/oe-status.yml
  - ops-heartbeat-smoke — .github/workflows/ops-heartbeat-smoke.yml
  - pages — .github/workflows/pages.yml
  - readme-lock — .github/workflows/readme-lock.yml
  - readme-smoke — .github/workflows/readme-smoke.yml
  - triage-guard — .github/workflows/triage-guard.yml
  - va-index — .github/workflows/va-index.yml
  - zz-smoke-simple — .github/workflows/zz-smoke-simple.yml
- Scripts:
  - scripts/BN_Canonical_Pull.ps1 (last: 2025-10-07T06:47:32Z)
  - scripts/CC_InlineCores.ps1 (last: 2025-10-07T06:47:32Z)
  - scripts/Ensure-AbBypass.ps1 (last: 2025-10-05T23:28:56Z)
  - scripts/metrics_badges.ps1 (last: 2025-10-17T21:15:17Z)
  - scripts/metrics_harvest.ps1 (last: 2025-10-17T16:58:31Z)
  - scripts/metrics_index_inject_badges.ps1 (last: 2025-10-17T20:01:07Z)
  - scripts/metrics_index.ps1 (last: 2025-10-18T00:51:35Z)
  - scripts/metrics_stale_check.ps1 (last: 2025-10-17T18:26:33Z)
  - scripts/metrics_trends.ps1 (last: 2025-10-17T19:24:32Z)
  - scripts/normalize_cardswraps.ps1 (last: 2025-09-15T21:05:46Z)
  - scripts/oe_status.ps1 (last: 2025-09-15T21:05:46Z)
  - scripts/render_sparklines.ps1 (last: 2025-10-17T18:26:37Z)
  - scripts/trust_scan.ps1 (last: 2025-09-15T21:05:46Z)

## Notes
- Regenerate: pwsh -File scripts/metrics_index.ps1
- Retention: 90 days via scripts/metrics_harvest.ps1
- Staged scripts manifest: metrics/coops_manifest.json




