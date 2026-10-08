# AwesomeCI Smarter Testing demo

Short live demo of CircleCI [Smarter Testing](https://circleci.com/docs/guides/test/getting-started-with-circleci-testing-tool/): test impact analysis, dynamic test splitting, and auto-rerun of failed tests.

To try it, push a branch and open its pipeline. Every workflow below runs on every push.

## What runs in CI

Four workflows, all on push:

- `classic-full-suite` — always the full **~9.7k** Jest cases, **15-wide**, split by **name** (old `circleci tests glob` / `circleci tests split` path). No TIA.
- `smarter-testing` — `circleci testsuite run "demo tests"` using [`.circleci/test-suites.yml`](.circleci/test-suites.yml), **2-wide**, TIA + dynamic split + auto rerun, Linux Docker.
- `android-smarter-testing` — `circleci testsuite run "android unit tests"`: a small Kotlin/JVM module in [`android/`](android/) with JUnit 4 tests via Gradle, on `cimg/android`, 2-wide. Coverage for TIA comes from JaCoCo, converted to LCOV.
- `ios-smarter-testing` — `circleci testsuite run "ios unit tests"`: a small Swift package in [`ios/`](ios/) with XCTest via `swift test`, on the macOS executor, 2-wide. Coverage for TIA comes from `llvm-cov` LCOV export.

Both Jest workflows use the same settings (`--maxWorkers=2`, `DEMO_TEST_DELAY_MS=15`), so they differ only in parallelism, split strategy and test selection.

`scripts/demo/collect-numbers.mjs` summarises a run. Its duration column is the job duration shown on the CircleCI job page; workflow wall clock is a separate column.

The main demo path is the generated e-commerce suite in [`demo/`](demo/) (212 modules). The large generated React suite under `react/` is leftover from an older splitting showcase and is **not** run by these workflows.

Pipeline parameters `run-classic`, `run-smarter`, `run-android` and `run-ios` (all default `true`) switch workflows off for API-triggered runs. `scripts/demo/trigger-run.sh` starts one from the CLI.
