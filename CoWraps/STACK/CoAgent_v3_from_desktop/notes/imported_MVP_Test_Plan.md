# CoAgent MVP Test Plan

## Scope under test
Queue Watcher, Repo Mutex, Read-Only Default, Logs, Rollback Bundle, DO Header Spec v0.1 parsing.

## Entry criteria
- Business Plan Review.md current
- RFC-0001 in Draft
- Hello.md sample DO present

## Test matrix (pass/fail)
| ID | Area | Scenario | Steps | Expected | Result |
|----|------|----------|-------|----------|--------|
| P-1 | Queue | File stability | Drop file; modify during render; run | CoAgent defers until size+hash stable |  |
| P-2 | Mutex | Two DOs target same repo | Launch in two PS7 windows | Second blocked; clear banner after unlock |  |
| P-3 | ReadOnly | DO tries Set-Content | Run with default flags | Blocked; risk badge shown |  |
| P-4 | DryRun (later) | Destructive cmd present | Dry-run preview; typed confirm | Preview rendered; confirm required |  |
| P-5 | Logging | Run passes/fails | Check JSON/txt logs | Masked secrets; exit code; risk flags present |  |
| P-6 | Rollback | Intentional failure mid-run | Verify restore | Worktree restored; diff clean |  |
| P-7 | Spec | Malformed header | Missing risk.* | Rejected with actionable error |  |

## Exit criteria (ship/no-ship)
- All P-tests pass twice in a row
- No unmitigated Sev-1 in Risk Register
- RFC-0001 comment window open (or resolved)
