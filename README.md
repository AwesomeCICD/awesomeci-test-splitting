# AwesomeCI Smarter Testing demo

Short live demo of CircleCI [Smarter Testing](https://circleci.com/docs/guides/test/getting-started-with-smarter-testing/) (beta): test impact analysis, dynamic test splitting, and auto-rerun of failed tests.

**Start at [demo.md](demo.md)** — 5–10 minute presenter script, trigger clicks, and the exact CLI commands.

## What runs in CI

Two workflows on Linux Docker by default:

- `classic-full-suite` — discover the demo tests and run all of them (old `circleci tests glob` / `circleci tests split` path).
- `smarter-testing` — `circleci testsuite run "demo tests"` using [`.circleci/test-suites.yml`](.circleci/test-suites.yml).

The demo path is the six Jest files in [`demo/`](demo/). The large generated React suite under `react/` is leftover from an older splitting showcase and is **not** run by these workflows.

Set `run-macos: true` on **Trigger Pipeline** to run the same jobs on a CircleCI macOS VM instead of Linux. Details are in `demo.md`.
