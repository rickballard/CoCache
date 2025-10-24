# CoSync Receipt Schema (minimal)
All receipts live in `status/log/cosync_YYYYMMDD.jsonl` (one JSON object per line).

Required:
- when   (RFC3339/ISO8601 "o")
- repo   (string; emitting repo name)
- area   (string; e.g., advice, viz, intent, housekeeping)
- type   (string; progress | alert | note | error)
- summary(string; single-line)
- data   (object; free-form payload)
- source (string; e.g., agent | cosync-emit | operator)

Identity/Trace (recommended):
- user    { anon: bool, hint?: string }
- session { role: string, id?: string }
- actor   { type: "ai"|"human", name: string, version?: string }
- run     { id?: string }

Example:
{
  "when":"2025-10-24T15:10:00Z",
  "repo":"CoCache","area":"advice","type":"note",
  "summary":"SeedCrystal AdviceBomb ingested",
  "data":{"file":"Advice_SeedCrystal_20251024_153510.zip","sha256":"..."},
  "user":{"anon":true,"hint":"Chris@local"},
  "session":{"role":"CoPrime","id":"cp-20251024-A"},
  "actor":{"type":"ai","name":"GPT-5 Thinking"},
  "run":{"id":"uuid-or-timestamp"},
  "source":"agent"
}
