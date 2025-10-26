# Stability Detector
- Churn rate: % KPIs changed per version (low <10%, moderate 10–30%, high >30%).
- Effect drift: |effect_t - effect_{t-1}| / baseline (<5% for 3 versions → plateaued).
- CI tightening: width_t / width_{t-1} < 0.9 across 2 versions → improving certainty.
- Tempo: days between versions (<30d → emergent).
States: emergent, fast-evolving, converging, plateaued, regressing.
