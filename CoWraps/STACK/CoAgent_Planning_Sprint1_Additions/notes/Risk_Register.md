# Risk Register

| ID | Risk | Likelihood | Impact | Mitigation | Owner |
|----|------|------------|--------|------------|-------|
| R1 | Duplicate watchers cause double-runs | Med | Med | Enforce-SingleWatcher; lockfile | Planning |
| R2 | DO without header | Low | Med | Header check & reject | Runtime |
| R3 | Conflicting edits to same repo file | Med | High | Human-in-the-loop; notes/DOs; later policy gates | Planning |
| R4 | Packaging confusion | Med | Med | Starter Kit docs; post-install smoke | Planning |
