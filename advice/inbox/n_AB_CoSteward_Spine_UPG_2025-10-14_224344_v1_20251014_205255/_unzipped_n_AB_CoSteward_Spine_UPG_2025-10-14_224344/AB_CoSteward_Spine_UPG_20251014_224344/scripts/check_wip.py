import sys, yaml
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    data = yaml.safe_load(f)
active = data.get('active', [])
max_human = 4
assert len(active) <= max_human, f"WIP cap exceeded: {len(active)} active (max {max_human})"
for s in active:
    for k in ['owner','goal','next_commit','dod']:
        assert s.get(k), f"Missing '{k}' in stream {s.get('id')}"
print("WIP OK (human streams)")
