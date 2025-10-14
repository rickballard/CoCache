# Risks

- Over-relaxing protections during launch could allow unwanted changes — mitigated by keeping Critical set locked.
- API surface variance (404/403) across repos may hide misconfigurations — mitigated by `rg-status` checks.
- Force-push sub-endpoint may be unavailable; rely on required checks/reviews where needed.
