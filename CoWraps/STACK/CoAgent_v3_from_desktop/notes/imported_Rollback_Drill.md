# Rollback Drill (P0)

Goal: Rehearse safe recovery of a failed run that created a commit.

Procedure:
1) DO creates commit then throws.
2) Tool writes Rollback_Instructions.txt containing: git -C '<repo>' reset --hard HEAD~1
3) Operator executes the instruction; verify clean state.

Pass:
- HEAD moved back; working tree clean; logs contain the exact command executed.
