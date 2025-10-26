# Merge‑or‑Race Protocol (MORP)

Similarity S = 0.5·cosine(embedding) + 0.5·Jaccard(objectives)
- Merge if S ≥ 0.75 (freeze contracts, combine KPIs, staged integration)
- Race if 0.45 ≤ S < 0.75 (champion–challenger, shared eval harness)
- Else independent

End race with Expected Value of Information (EVI): stop if EVI < Cost_of_Dual_Path.

