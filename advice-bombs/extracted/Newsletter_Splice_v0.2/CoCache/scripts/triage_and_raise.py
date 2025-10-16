
import argparse, os

parser = argparse.ArgumentParser()
parser.add_argument("--week", default="latest")
parser.add_argument("--rickpublic", required=True)
parser.add_argument("--rickdo", required=True)
args = parser.parse_args()

summ_dir = "CoCache/synth/weekly_summaries"
weeks = sorted([f for f in os.listdir(summ_dir) if f.endswith(".md")])
if not weeks:
    print("No weekly summaries found."); raise SystemExit(0)
week_file = weeks[-1] if args.week == "latest" else f"{args.week}.md"
week_tag = week_file[:-3]

# Prepare RickPublic issue
dest_issue = os.path.join(args.rickpublic, "issues", week_tag + ".md")
os.makedirs(os.path.dirname(dest_issue), exist_ok=True)
with open(os.path.join(summ_dir, week_file), "r", encoding="utf-8") as f:
    body = f.read()

header = f"""---
title: CoCivium Weekly - {week_tag}
subtitle: Signals, Diffusion, Risks, and Moves
canonical: https://github.com/rickballard/RickPublic/blob/main/issues/{week_tag}.md
---
"""
with open(dest_issue, "w", encoding="utf-8") as f:
    f.write(header + "\n" + body.split("---\n",2)[-1])
print(f"Prepared: {dest_issue}")

# Update RickDo README
do_readme = os.path.join(args.rickdo, "README.md")
existing = ""
if os.path.exists(do_readme):
    existing = open(do_readme,"r",encoding="utf-8").read()

year, wk = week_tag.split("-W")
try:
    yw = int(wk)
except:
    yw = 1

lines = [f"- {week_tag} - *Signals, Diffusion, Risks, and Moves*. [[markdown]](https://github.com/rickballard/RickPublic/blob/main/issues/{week_tag}.md)"]
for i in (1,2):
    w = yw - i
    if w < 1: break
    lines.append(f"- {year}-W{w:02d} - [[markdown]](https://github.com/rickballard/RickPublic/blob/main/issues/{year}-W{w:02d}.md)")

block = "## CoCivium Weekly Briefs\n" + "\n".join(lines) + """
\n[![Latest Weekly Brief](https://img.shields.io/badge/CoCivium-Weekly_Brief-blue)](https://github.com/rickballard/RickPublic/tree/main/issues)
[![Live Signals](https://img.shields.io/badge/Signals-Live-lightgrey)](https://github.com/rickballard/CoCache/tree/main/synth/weekly_summaries)
"""

if "## CoCivium Weekly Briefs" in existing:
    new = existing.split("## CoCivium Weekly Briefs")[0] + block
else:
    new = "# CoSteward (formerly RickDo) - Front Door\n\n" + block

with open(do_readme,"w",encoding="utf-8") as f:
    f.write(new)
print("Updated RickDo README list.")
