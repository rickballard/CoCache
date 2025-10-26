# DECISIONS

- **Zip-first BPOE**: ship payload + installers; keep DO blocks short.
- **Programmatic diagrams**: source of truth in JSON; Mermaid rendered via CDN.
- **Square-bracket Mermaid nodes** to avoid quote/paren escaping issues in PS here-strings.
- **Idempotent installers** with Inject-Once and UTF-8 (no BOM).