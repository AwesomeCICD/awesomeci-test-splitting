# Smarter Testing live demo (15 min)

Presenter script for a regulated financial services audience (retirement, wealth, payments). Mostly live screenshare of the CircleCI web app, a terminal and this repo, with a few slides as bookends (kept outside this public repo).

The audience should leave knowing three things:

1. Test impact analysis (TIA) runs only the tests a change touches, and logs why each test was selected.
2. Dynamic test splitting does the full suite on 2 nodes for a third of the credits of a 15-node static split.
3. None of this weakens controls: the default branch still runs everything, and you decide what always runs.

## Availability (say this accurately)

- Smarter Testing (`circleci testsuite` plus TIA, dynamic test splitting and auto rerun) is a **CircleCI cloud** feature. The docs list the Free, Performance and Scale cloud plans and all supported VCS providers.
- It is **not available on CircleCI Server**. Server keeps `circleci tests glob` / `circleci tests split`.
- The built-in parts of `circleci testsuite` (timing-based static splitting, rerun only failed tests on "Rerun workflow from failed") are free. TIA, dynamic test splitting and auto rerun are the Smarter Testing features, each enabled independently in `.circleci/test-suites.yml`.
- Earlier material called Smarter Testing a beta. Check the current release status before quoting it.

Docs: [getting started](https://circleci.com/docs/guides/test/getting-started-with-circleci-testing-tool/), [test impact analysis](https://circleci.com/docs/guides/test/set-up-test-impact-analysis/), [dynamic test splitting](https://circleci.com/docs/guides/test/use-dynamic-test-splitting/), [auto rerun](https://circleci.com/docs/guides/test/auto-rerun-failed-tests/), [config reference](https://circleci.com/docs/reference/testsuite-configuration-reference/).

## What is in the repo

| | Classic `classic-full-suite` | Smarter `smarter-testing` |
| --- | --- | --- |
| Tests | **9,716** Jest cases in **212** files (`demo/src/<domain>/`) | Same suite |
| Parallelism | **15** | **2** |
| Split | `circleci tests split --split-by=name` | Dynamic test splitting (shared queue) |
| Selection | Always the full suite | TIA on feature branches, full suite on `main` |
| Retries | None | `max-auto-rerun: 1` |
| Jest (default) | `--runInBand`, `DEMO_TEST_DELAY_MS=300` | `--maxWorkers=2`, `DEMO_TEST_DELAY_MS=15` |

The default classic job is deliberately unoptimized. For an apples-to-apples comparison, the `vijay-2026-10-08-demo-like-for-like` branch gives classic the same Jest workers and per-test delay as smarter. Use those numbers when anyone asks "is that fair?".

## Branches for this demo

All branch off `vijay-2026-10-08-demo`. None of them touch `main`.

| Branch | What it changes | What it shows |
| --- | --- | --- |
| `vijay-2026-10-08-demo` | Adds `scripts/demo/` helpers and this script | Baseline: classic 15-wide vs smarter 2-wide |
| `vijay-2026-10-08-demo-tia-withholding` | One behaviour-preserving edit to `demo/src/tax/withholding.js` | TIA selects 1 of 212 test files |
| `vijay-2026-10-08-demo-flaky-auto-rerun` | Adds `demo/src/payments/settlementCutoff.js` and a test that fails once per fresh container | Smarter auto-reruns it and goes green; classic goes red |
| `vijay-2026-10-08-demo-like-for-like` | Classic uses `--maxWorkers=2` and a 15 ms delay, like smarter | Fair full-suite comparison: 15 nodes vs 2 |

Helpers:

- `scripts/demo/tia-change.sh [module]`: creates `vijay-2026-10-08-demo-tia-<module>-<timestamp>` off the demo branch with a one-module refactor, commits and pushes it, and prints the pipeline URL. Default module: `demo/src/tax/withholding.js`. `NO_PUSH=1` commits without pushing.
- `scripts/demo/collect-numbers.mjs`: wall clock, nodes, test counts and credits per workflow from CircleCI API v3 (`CIRCLE_TOKEN` required).

## Real numbers (Linux Docker `medium`, 7-8 Oct 2026)

| Scenario | Workflow | Nodes | Tests run | Wall clock | Credits |
| --- | --- | --- | --- | --- | --- |
| Classic default (unoptimized) | [pipeline 230](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/230/workflows/0d726aee-07e4-4e37-a63e-337f3a9a884b) | 15 | 9,716 | 3m 46s | 549 |
| Classic like-for-like | [pipeline 233](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/233/workflows/7af6e6ab-4c12-4213-ba44-9f57eafc670e) | 15 | 9,716 | 38s | 71 |
| Smarter, full suite (dynamic split) | [pipeline 233](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/233/workflows/4926a41b-976e-44a3-b002-a8d0c981441f) | 2 | 9,716 | 60s | 22 |
| Smarter, one-module change (TIA) | [pipeline 236](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/236/workflows/a8931066-89d4-4da3-84b7-e5e8501f6eaf) | 2 | 52 (1 file, 211 skipped) | 18s | 7 |
| Smarter, flaky test (TIA + auto rerun) | [pipeline 237](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/237/workflows/1749229f-2d04-44a3-ab6b-f213718c2710) | 2 | 8 (failed once, rerun passed) | 16s | 7 |
| Classic, same one-module change | [pipeline 236](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/236/workflows/4cf86539-e5be-4fb3-b256-785f675377e7) | 15 | 9,716 | 3m 46s | 547 |
| Classic, same flaky test | [pipeline 237](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/237/workflows/b7def7e1-eec3-44aa-be7d-744050056289) | 15 | 9,724 (1 failed) | 3m 48s, red | 546 |
| Smarter, docs-only change | [pipeline 238](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/238/workflows/31b5976a-131b-4c41-ab3c-353d78de2a16) | 2 | 0 (all 212 files skipped) | 14s | 6 |

Headline ratios: dynamic split runs the whole suite for **69% fewer credits** than the like-for-like 15-node split (22 vs 71), at the cost of about 22 seconds. TIA on a one-module change uses **90% fewer credits** than the like-for-like classic run (7 vs 71) and finishes in less than half the time. Wall clock is workflow created to ended, so it includes container spin-up.

Re-collect any time:

```bash
CIRCLE_TOKEN=... node scripts/demo/collect-numbers.mjs --branch vijay-2026-10-08-demo-tia-withholding
```

## Before the room

Do these the day before and again 30 minutes before.

1. CLI logged in, testsuite extension installed:

   ```bash
   circleci auth me
   circleci extension install testsuite   # once
   ```

2. Local repo on the demo branch with dependencies installed:

   ```bash
   git switch vijay-2026-10-08-demo && git pull
   (cd demo && npm ci)
   ```

3. **Refresh impact data.** TIA needs current impact data in CircleCI. On 7 Oct the stored data had aged out and every feature branch fell back to "Selecting all test atoms, no impact analysis available". The fix that worked, from the repo root on the demo branch (about 2.5 minutes):

   ```bash
   circleci testsuite run "demo tests" --run-tests=none --analyze-tests=impacted
   ```

   It ends with `Updated test impact data`. Then confirm selection against CircleCI's data (no `--local`):

   ```bash
   git switch vijay-2026-10-08-demo-tia-withholding
   circleci testsuite list-tests "demo tests"     # expect: demo/src/tax/withholding.test.js
   git switch vijay-2026-10-08-demo
   ```

4. **Pipelines must be push-triggered.** On this project, pipelines started from the API, the CLI (`circleci run trigger`) or "Trigger Pipeline" currently fail at checkout with `Permission denied (publickey)`. Push-triggered pipelines and workflow reruns are fine. If you need a fresh run on a helper branch, push an empty commit:

   ```bash
   git switch vijay-2026-10-08-demo-tia-withholding
   git commit --allow-empty -m "Start a fresh pipeline" && git push
   ```

   Do not use "Rerun workflow" to show TIA. A rerun skips tests that already passed in that workflow ("Detected rerun, skipping previously successful test atoms"), which is the rerun-failed-tests feature, not TIA.

5. Tabs, left to right:
   1. Slides (title, problem, what you will see).
   2. [Pipelines filtered to the demo branch](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting?branch=vijay-2026-10-08-demo).
   3. Classic baseline: pipeline 230 `classic-tests` job.
   4. TIA: pipeline 236 `smarter-tests` job, Tests tab.
   5. Like-for-like: pipeline 233 workflow map.
   6. Flaky: pipeline 237, both the `smarter-tests` job (step output) and `classic-full-suite` (red).
   7. Editor on `.circleci/test-suites.yml` and `demo/src/tax/withholding.js`.
   8. Terminal at the repo root, font size up, `clear`ed.

6. macOS: the `run-macos` parameter path cannot be shown right now because it needs a triggered pipeline (see step 4). Talk to it, do not demo it.

## Run of show

| Time | Segment | Screen |
| --- | --- | --- |
| 0:00-1:00 | Open: the problem | Slides |
| 1:00-1:30 | What you will see | Slide |
| 1:30-3:30 | Baseline: classic, 15 wide | CircleCI, pipeline 230 |
| 3:30-5:30 | One config file, one command (kick off the live TIA push first) | Terminal, editor |
| 5:30-8:30 | Test impact analysis | CircleCI, live branch or pipeline 236 |
| 8:30-10:30 | Dynamic splitting, 2 nodes vs 15 | CircleCI, pipeline 233 |
| 10:30-12:30 | Flaky test: auto rerun and rerun from failed | CircleCI, pipeline 237 |
| 12:30-14:00 | Why it matters in a regulated shop | Slide |
| 14:00-15:00 | Pilot plan and the ask | Slide |
| +5 min | Q&A buffer | |

### 0:00-1:00 Open: the problem

**Show:** title slide, then the problem slide.

**Say:**

- "Every team here has a test suite that only grows. Today a one-line change still runs all of it."
- "In this repo that is 212 test files, 9,716 tests, on 15 machines, every push. The usual answer is more parallelism, which buys speed by paying for every node on every run."
- "I'll show the alternative live: run what the change touches, split the rest smartly, and keep the full suite where you need it for control."

### 1:00-1:30 What you will see

**Show:** the five-step slide. Read the five lines, no more.

### 1:30-3:30 Baseline: classic, 15 wide

**Clicks:**

1. Pipelines tab, pipeline 230, `classic-full-suite`, job `classic-tests`. Point at the **15** parallel runs.
2. Open node 0, step **Discover and run the full suite**: "Discovered 212 test files", then the name-based split for that node.
3. Open a late-alphabet node (13 or 14, `users` / `warehouse`): heavier shard, finishes last.
4. **Tests** tab: 9,716 passed.

**Say:**

- "This is the pattern most of us run today: glob every test, split by name, run them all."
- "Look at the shard spread. The heaviest node sets the pace and the rest sit idle at the end."
- "549 credits and almost four minutes. Nothing about this run knew that only one file changed."

**Wow:** the full suite ran for a change that touched nothing in it.

### 3:30-5:30 One config file, one command

**First, kick off the live TIA change** so it is finished by 5:30:

```bash
scripts/demo/tia-change.sh
```

It creates and pushes `vijay-2026-10-08-demo-tia-withholding-<timestamp>` with a single edit to `demo/src/tax/withholding.js` and prints the pipeline URL. Want proof it is not canned? Pass another module, for example `scripts/demo/tia-change.sh demo/src/pricing/quote.js`. Then `git switch vijay-2026-10-08-demo` to get back.

**Show:** `.circleci/test-suites.yml` in the editor.

```yaml
name: demo tests
discover: demo/discover.sh
run: ... demo/jest.sh --ci --maxWorkers=2 --runTestsByPath << test.atoms >>
analysis: ... --coverage ... && cp /tmp/tia-coverage/lcov.info "<< outputs.lcov >>"
options:
  test-impact-analysis: true
  dynamic-test-splitting: true
  max-auto-rerun: 1
  full-test-run-paths: [demo/package.json, demo/package-lock.json, demo/jest.config.cjs, demo/jest.sh, .circleci/*.yml]
```

**Say:**

- "Four commands: how to find tests, how to run them, how to run them with coverage, where results go. The options switch each feature on independently."
- "`full-test-run-paths` is the safety valve: change a dependency file or the CI config and everything runs."
- "In the job, the whole test step becomes one line: `circleci testsuite run "demo tests"`."

**Terminal (live, about 17 seconds):**

```bash
circleci testsuite doctor "demo tests"
```

Point at the checks passing: discover found 212 atoms, run works, analysis maps tests to source files.

Optional, if time (instant): what would CI select for the TIA branch?

```bash
git switch vijay-2026-10-08-demo-tia-withholding
circleci testsuite list-tests "demo tests"
git switch vijay-2026-10-08-demo
```

Expected: `demo/src/tax/withholding.test.js`, nothing else.

**Wow:** `doctor` validates the whole setup in seconds, before anyone touches CI.

### 5:30-8:30 Test impact analysis

**Clicks:**

1. Open the pipeline URL `tia-change.sh` printed. If it is not done, use pipeline 236 (same change).
2. `smarter-testing` job `smarter-tests`, step **Run smarter tests**. Open the node that ran tests (the other can be idle). Read the selection block out loud:

   ```text
   Selecting tests...
   Found test impact generated by: ...
   - 1 test atoms impacted by modified files
   Selected 1 test atoms, Skipped 211 test atoms
   ```

3. **Tests** tab: 52 passed, 9,664 skipped. The reason is visible, not a black box.
4. Side by side: the `classic-full-suite` workflow on the same branch is still running all 9,716 tests on 15 nodes (about 4 minutes, about 550 credits).

**Say:**

- "We changed one tax module. Smarter Testing knew, from coverage on the default branch, that exactly one test file exercises it."
- "52 tests instead of 9,716. 18 seconds and 7 credits against 71 credits for the like-for-like classic run, and 547 for the default classic run on the same commit (pipeline 236)."
- "Selection is conservative: new tests, tests that failed last time on this branch, and tests covering any changed or deleted file always run."
- "And it is your rules: `full-test-run-paths` forces a full run, `test-selection-rules` pins tests that must always run, and the default branch runs everything while it refreshes the impact data."

**Wow:** one file changed, one test file ran, and the log says why.

### 8:30-10:30 Dynamic splitting, 2 nodes vs 15

**Clicks:**

1. Pipeline 233 (like-for-like branch). Both workflows ran the full 9,716 tests with the same Jest settings.
2. `classic-tests`: 15 nodes, 38s, 71 credits.
3. `smarter-tests`: 2 nodes, 60s, 22 credits. **Timing** tab: both nodes pull from one queue and finish together.

**Say:**

- "Same tests, same settings. Fifteen static shards finish in 38 seconds. Two nodes pulling from a shared queue finish in a minute for 69% fewer credits."
- "That's the trade you get to choose. On the default branch, where the full suite runs, two well-balanced nodes may be all you need."
- "Static timing-based splitting is free with `testsuite`. Dynamic splitting is the Smarter Testing upgrade that copes with slow or uneven nodes."

**Wow:** a third of the compute for the same full suite.

### 10:30-12:30 Flaky test: auto rerun and rerun from failed

**Clicks:**

1. Pipeline 237 (`vijay-2026-10-08-demo-flaky-auto-rerun`), `smarter-tests`, step **Run smarter tests**:

   ```text
   - 1 new test atoms
   Selected 1 test atoms, Skipped 212 test atoms
   ✕ reads the cutoff from a warm calendar cache
   Rerunning failed tests...
   Tests: 8 passed, 8 total
   ```

   Job green. The Tests tab still records the failed attempt.

2. Pipeline 237 `classic-full-suite` on the same commit: red, 3m 48s, 546 credits, for one flaky test.

**Say:**

- "This settlement-cutoff test fails the first time in a fresh container, like a cold cache timing out. Classic goes red and someone has to rerun 15 nodes."
- "Smarter Testing retried only that one test, in the same job, and recorded the flake. It didn't hide it."
- "Without auto rerun, 'Rerun workflow from failed' on a `testsuite` job reruns only the failed tests, not the whole suite. That part is free."
- "`max-auto-rerun` and `auto-rerun-duration` cap how much retrying you allow, so flakes can't quietly eat the budget."

**Wow:** a flaky failure turned green by retrying one test, with the evidence kept.

### 12:30-14:00 Why it matters in a regulated shop

**Show:** the value slide.

**Say:**

- "Controls stay where they are: the default branch runs every test, release branches can run `--run-tests=all`, and every selection, skip and retry is in the job log and Tests tab."
- "Credits follow the change instead of the fan-out."
- "Adoption is incremental: switch a suite to `circleci testsuite` for the free features, then turn on TIA for that one suite."

### 14:00-15:00 Pilot plan and the ask

**Show:** the pilot slide. One suite, four weeks: baseline, switch to `testsuite`, turn on TIA and dynamic splitting, measure. Ask for a candidate suite and an owner.

## If something goes wrong live

| Symptom | Likely cause and fallback |
| --- | --- |
| TIA branch runs all 212 files, log says "no impact analysis available" | Impact data is missing or aged out. Show pipeline 236 instead. Afterwards, rerun the refresh command in "Before the room". |
| All tests selected with a reason under "full test run paths" | The change touched `.circleci/*.yml` or a `demo/` dependency or Jest file. Expected. Use a source-only change. |
| Live pipeline still queued at 5:30 | Show pipeline 236 and come back to the live one at the end. |
| `circleci testsuite` not found | `circleci extension install testsuite` |
| A node says "Ran 0 test atoms" | Expected on the idle node after TIA. Open the other node or the job Tests tab. |
| Trigger Pipeline / `circleci run trigger` fails at checkout | Known project issue (checkout key for triggered pipelines). Push a commit instead. |
| A rerun shows 0 tests selected | Rerun skips tests that already passed in that workflow. Use a fresh push for TIA. |

## Reference: pipeline parameters

| Parameter | Default | Effect |
| --- | --- | --- |
| `run-classic` | `true` | Run `classic-full-suite` |
| `run-smarter` | `true` | Run `smarter-testing` |
| `run-macos` | `false` | Run the same jobs on macOS (`xcode: 26.6.0`, `m4pro.medium`, parallelism 2) instead of Linux |

Parameters only apply to triggered pipelines, which currently fail at checkout on this project (see "Before the room").
