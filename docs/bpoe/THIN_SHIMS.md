# BPOE: Thin Shims (central CI via CoCache)

Goal: keep each repo light. Add three tiny workflows that call reusable ones in CoCache:

  .github/workflows/smoke.yml
    name: smoke
    on: { push: { branches: ["**"] }, pull_request: {}, workflow_dispatch: {} }
    jobs: { call: { uses: rickballard/CoCache/.github/workflows/bpoe-smoke.yml@main, with: { fail_external: false } } }

  .github/workflows/safety-gate.yml
    name: safety-gate
    on: { pull_request: { types: [opened, synchronize, reopened] } }
    jobs: { call: { uses: rickballard/CoCache/.github/workflows/bpoe-safety-gate.yml@main } }

  .github/workflows/self-evolve.yml
    name: self-evolve
    on: { workflow_dispatch: {}, schedule: [ { cron: "13 4 * * *" } ] }
    jobs: { call: { uses: rickballard/CoCache/.github/workflows/bpoe-self-evolve.yml@main } }

Pin to a SHA for determinism by replacing @main with a CoCache commit.
If a repo is DO-only, stage shims under .github/workflows.disabled/ until allowed.

