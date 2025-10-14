# CoMap — Navigate the Future. Map Your World.

**CoMap** is a governance radar that visualizes civilizations and governance models across a fixed set of metrics using a spider/radar diagram. It is the top-level map in a family of CoCivium “maps,” designed for virality, debate, and co‑evolution.

## MVP Feature Set
- Immutable **metrics schema**; adjustable **scores/weights** per model.
- Compare overlays: **CoCivium Ideal**, **Star Trek Federation**, **Star Wars Empire**, **Nordics**, **USA**, others.
- Exports: **PNG**, **JSON config**, **embeddable widget**.
- Watermark + link-back to **CoCivium**.
- Optional gallery and AI suggestions.

## Repo Skeleton
```
/frontend      # Interactive app (React/Tailwind; shadcn UI; radar chart render)
/backend       # Minimal API (templates, save/load, gallery)
/maps          # JSON templates for models
/docs          # Methodology, scoring, alignment with CoCore/CoNeura
/dist          # Packaged builds (PWA/Electron)
/insights      # Research notes, comparisons, roadmap
```

## License & Ethics
- Open-core: permissive client, transparent methodology; contributions logged via CoCache/CoWraps.
- No coercive “congruence”; transparency-first scoring with rationale and sources.
