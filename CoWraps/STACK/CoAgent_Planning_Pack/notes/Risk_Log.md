# Risk Log (Lightweight)

| ID | Risk | Likelihood | Impact | Mitigation | Owner | Status |
|----|------|------------|--------|------------|-------|--------|
| R1 | Duplicate watchers cause races | M | M | Single‑watcher guard; registry repair | Planning | OPEN |
| R2 | DO runs without proper header | L | H | Header gate + reject path | Planning | OPEN |
| R3 | ccts fallback regression | M | M | Test DO; harness in CI | Migrate | OPEN |
