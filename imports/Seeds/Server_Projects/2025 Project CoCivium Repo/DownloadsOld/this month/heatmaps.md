# Disagreement Heatmaps

Disagreement heatmaps visualize the divergence of views across Civium's consensus layers—individuals, models, institutions, and timelines.

They are tools for:
- Identifying issues with high epistemic tension
- Prioritizing zones of clarification or deliberation
- Surfacing ethical risk or manipulation hotspots
- Showing long-term convergence or fragmentation patterns

---

## 📊 Sample Heatmap Schema

```yaml
issue_id: civium-issue-042
title: Executive Power in Crisis Scenarios
time_range:
  start: 2025-06-01
  end: 2025-07-01
participants:
  - name: GPT-Concordia-v4
    consensus_score: 0.72
    disagreement_level: mild
  - name: HumanPanel_X7
    consensus_score: 0.41
    disagreement_level: strong
  - name: CollectiveMind-ForkB
    consensus_score: 0.88
    disagreement_level: clear
consensus_score: 0.67
disagreement_level: moderate
last_updated: 2025-07-10T08:52:00Z
notes: |
  High divergence on use-of-force thresholds and AI override authority.
  Recommend multi-model clarification session.
```

---

## 🔍 Use Cases

- **Moderation Alerts:** When `disagreement_level: strong`, trigger review.
- **Policy Review:** Surfacing historical instability in debated laws.
- **AI Alignment Audits:** Show where model forks consistently disagree.
- **Meta-governance:** Chart health of system-wide consensus over time.

---

## 🔮 Future Features

- Heatmap overlays across Civium issue maps
- Drill-down filters by actor type, date, domain
- Visual timelines of convergence/disruption
- Integrate with live debates + "clarify mode"
