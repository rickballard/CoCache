# Playbook: Seed Ingestion (locals-first, server-sliced)

## Why
UNC scanning can stall silently (SMB/antivirus/latency). Split sources and throttle the server queue.

## Steps (short form)
1) Build queues from discovery map → `imports/_queues/_queue_{desktop,downloads,server}.csv`.
2) Ingest locals with `r9q` (`BATCH=5000`), push every 2 passes.
3) Ingest server with `r9q` in slices (`BATCH=800`), retry if `is_stale` trips.
4) Commit manifests and STATUS logs via `p11`.

## Commands (copy/paste)
- Build queues: DO-BLOCK 20
- Run locals:   DO-BLOCK 22
- Run server:   DO-BLOCK 23
