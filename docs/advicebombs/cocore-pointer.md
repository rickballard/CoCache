# Pointer: CoCore shared congruence workflow

Prefer the reusable CI job from **CoCore** to compute & optionally write congruence scores.

Usage in this repo’s workflows:
```yaml
jobs:
  congruence:
    uses: rickballard/CoCore/.github/workflows/congruence.yml@main
    with:
      targets: |
        patterns/**/congruence.json
      write: false   # set true in maintenance branches only
      strict: false  # allow missing/partial while seeding
Reference code (read-only): CoCore → tools/congruence/

