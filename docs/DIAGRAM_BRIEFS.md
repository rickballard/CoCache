# DIAGRAM BRIEFS
Format per brief:
- Title
- Nodes (one per line, short labels)
- Edges (A → B)

## Partner ecosystem — intro → deal
Nodes:
A: Lead source
B: Intro channel
C: Intake form
D: Triage
E: Founder call
F: Diligence
G: Offer
H: Close

Edges:
A → B
B → C
C → D
D → E
E → F
F → G
G → H

## InSeed weekly content loop
Nodes:
1: Inputs (links/notes)
2: Curate (Corpus Sweep)
3: Drafts (outline)
4: Edit (passes)
5: Publish (site/newsletter)
6: Feedback (analytics/inbox)
7: Backlog (next topics)

Edges:
1 → 2
2 → 3
3 → 4
4 → 5
5 → 6
6 → 7
7 → 2

## CoSuite architecture — high level
Nodes:
A: CoCache
B: CoPolitic
C: InSeed
D: CI/CD
E: CoAgent (future)
F: Viewers
G: Operators

Edges:
G → A
G → C
A → B
C → B
B → F
A → D
C → D
B → D
A → E
C → E
E → B
