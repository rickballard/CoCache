
import argparse, os, json, datetime

def score_item(sc):
    return 0.35*sc.get("impact",0)+0.2*sc.get("evidence",0)+0.2*sc.get("forkability",0)+0.15*sc.get("risk_delta",0)+0.1*sc.get("relevance",0)

parser = argparse.ArgumentParser()
parser.add_argument("--ingest", required=True)
parser.add_argument("--out", required=True)
args = parser.parse_args()

today = datetime.date.today()
start = today - datetime.timedelta(days=6)
items = []
for i in range(7):
    d = start + datetime.timedelta(days=i)
    path = os.path.join(args.ingest, d.strftime("%Y-%m-%d"), "normalized.jsonl")
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            for line in f:
                try:
                    j = json.loads(line)
                    sc = j.get("score_components", {})
                    j["score"] = score_item(sc)
                    items.append(j)
                except Exception:
                    pass

# Dedup by URL
seen = set(); dedup = []
for it in sorted(items, key=lambda x: x.get("date",""), reverse=True):
    url = it.get("url","")
    if url in seen: continue
    seen.add(url)
    dedup.append(it)

top = sorted(dedup, key=lambda x: x.get("score",0), reverse=True)[:5]
week = f"{today.isocalendar()[0]}-W{today.isocalendar()[1]:02d}"
os.makedirs(args.out, exist_ok=True)
outf = os.path.join(args.out, f"{week}.md")

lines = []
for i, it in enumerate(top, 1):
    summary = (it.get("summary_250c","") or "")
    if len(summary) > 220:
        summary = summary[:217].rstrip() + "..."
    lines.append(f"{i}) {it['title']} - {summary} [link]({it['url']})")

content = f"""---
week: {week}
generated: {today}
items_considered: {len(items)}
items_promoted: {len(top)}
planks: []
risk_alerts: []
---

## This week in CoCivium (<=150 words)
(Compose narrative based on Top Signals and any risk alerts.)

### Top Signals (<=5, 2-3 lines each)
{os.linesep.join(lines)}

### Diffusion Watch (<=3)
- (Add comparable pilots with links)

### Risk & Guardrails (<=3)
- (Add standards/reg/CVE with posture)

### Recommended Actions (<=5 checkboxes)
- [ ] (Proposed action)
"""
with open(outf, "w", encoding="utf-8") as f:
    f.write(content)
print(f"Wrote weekly summary: {outf}")
