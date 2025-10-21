# CoUp: Drive From Repos

- Repos are the source of truth (not chat history).
- Every workflow ends with a CoUp tail: (1) emit status receipt, (2) refresh CoDrift Index, (3) refresh indexes, (4) commit+push.
- No here-strings in scripts; keep DO blocks idempotent (see BPOE_RULES.md).
