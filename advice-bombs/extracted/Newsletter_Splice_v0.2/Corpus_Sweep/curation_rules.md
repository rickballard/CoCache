
# Curation Rules (2-Minute Score)

Each fresh item is scored 0-5:
- Decision impact (0.35)
- Evidence quality (0.20)
- Forkability (0.20)
- Risk delta (0.15)
- Relevance (0.10)

Priority = 0.35*Impact + 0.2*Evidence + 0.2*Forkability + 0.15*Risk + 0.1*Relevance

Routing:
- >= 4.2 -> PR (citations/notes or small CSV deltas)
- 3.0-4.19 -> Issue (needs eval)
- < 3.0 -> Logged in graveyard with reason

Sunset:
- PRs & Issues auto-close after 14 days unless touched; re-open once if score persists.
