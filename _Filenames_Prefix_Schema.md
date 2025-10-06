# Filename Prefix Schema (proposal)
- `.name` → canon/pillar documents.
- `..name` → **CC megascroll component** (also canon).
- `_name` → highlighted readable (front-page friendly).

Front-matter to include:
```yaml
canon_level: pillar|chartered|guideline|experiment
highlight: true|false
cc_component: true|false
Note: Windows supports leading . and _. The front-matter is the source of truth; prefixes are hints for humans.
