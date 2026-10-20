# AwesomeCI Smarter Testing demo

Short live demo of CircleCI [Smarter Testing](https://circleci.com/docs/guides/test/getting-started-with-smarter-testing/) (beta): test impact analysis, dynamic test splitting, dynamic parallelism, and auto-rerun of failed tests.

**Start at [demo.md](demo.md)** — 5–10 minute presenter script, trigger clicks, and the exact CLI commands.

## What runs in CI

Two workflows on Linux Docker by default:

- `classic-full-suite` — always the full **~9.7k** Jest cases, **15-wide**, split by **name** (old `circleci tests glob` / `circleci tests split` path). No TIA.
- `smarter-testing` — `smarter-list-tests` (`circleci testsuite list-tests --key=...`) then `smarter-tests` (`circleci testsuite run "demo tests"`) using [`.circleci/test-suites.yml`](.circleci/test-suites.yml). TIA + dynamic split + [dynamic parallelism](https://circleci.com/docs/guides/test/set-parallelism-dynamically/) (1–15 nodes, sized from the selected tests).

The demo path is the generated e-commerce suite in [`demo/`](demo/) (212 modules). The large generated React suite under `react/` is leftover from an older splitting showcase and is **not** run by these workflows.

Set `run-macos: true` on **Trigger Pipeline** to run the same jobs on a CircleCI macOS VM instead of Linux (parallelism capped at 2 — VMs are the bottleneck). Details are in `demo.md`.
