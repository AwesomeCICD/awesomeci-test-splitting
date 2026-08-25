# Smarter Testing live demo (5–10 min)

Presenter script. Start here. The audience should leave knowing why Smarter Testing is what you use when a huge suite would otherwise crush you.

Smarter Testing is in **beta**. The org must be on CircleCI cloud. There is no extra product flag in this repo, but if `circleci testsuite` fails in CI, the org may still need beta access.

## Scale (what you are showing)

| | Classic `classic-full-suite` | Smarter `smarter-testing` |
| --- | --- | --- |
| Tests | **9,716** cases in **212** files | Same suite |
| Parallelism | **15** (fixed) | **2** |
| Split | `circleci tests split --split-by=name` (not timings) | Dynamic test splitting + timing data |
| Selection | Always the **full** suite. No TIA. | TIA on feature branches |
| Jest | `--runInBand`, `DEMO_TEST_DELAY_MS=300` | `--maxWorkers=2`, `DEMO_TEST_DELAY_MS=15` |

Smarter is **2-wide on purpose**: after TIA, only `quote.test.js` is selected. At 30-wide, 29 nodes sat idle and presenters kept opening a container that said “Ran 0 test atoms.” Two nodes still show a split and the compute savings vs classic’s 15.

Layout: 12 independent e-commerce domains (`cart`, `catalog`, `checkout`, `coupons`, `inventory`, `payments`, `pricing`, `recommendations`, `shipping`, `tax`, `users`, `warehouse`). Later-alphabet domains have more tests per file, so a name-only split leaves **unbalanced shards** — that is a feature, not a bug.

Linux Docker is the **timing showcase**. macOS is the same jobs on a different executor (see below).

## Before the room (do this once)

1. Install and log in to the [CircleCI CLI](https://cli.circleci.com/):

   ```bash
   circleci auth login
   circleci auth me
   ```

2. Install the testsuite extension (not shipped with the CLI by default):

   ```bash
   circleci extension install testsuite
   ```

3. Confirm the project is followed: [AwesomeCICD/awesomeci-test-splitting](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting).

4. **Test impact analysis needs impact data first.** The default branch (`main`) must complete a `smarter-testing` run so analysis can upload coverage. A brand-new project, or a first push of this config, will run the **full** smarter suite (and can look slower than classic because of coverage analysis) until that data exists.

5. Work from the repo root. `test-suites.yml` lives at `.circleci/test-suites.yml`. The demo path is the generated Jest suite under `demo/src/<domain>/`. Do not wire `react/` into these workflows.

## How to trigger pipelines

| What you want | How |
| --- | --- |
| Default (Linux, both workflows) | Push to `main`, or **Trigger Pipeline** with defaults |
| Classic only | **Trigger Pipeline** → `run-classic: true`, `run-smarter: false` |
| Smarter only | **Trigger Pipeline** → `run-classic: false`, `run-smarter: true` |
| Same jobs on macOS | **Trigger Pipeline** → `run-macos: true` (Linux workflows are skipped) |

Project slug if you need it: `gh/AwesomeCICD/awesomeci-test-splitting`.

## 0:00–1:00 — Setup and the contrast

**Clicks**

1. Open `.circleci/config.yml`. Point at `classic-full-suite` (parallelism **15**) vs `smarter-testing` (parallelism **2**).
2. Open `.circleci/test-suites.yml`. Point at `test-impact-analysis`, `dynamic-test-splitting`, and `max-auto-rerun`. Classic does **not** use this file.
3. Open `demo/src/pricing/quote.js`. That is the file you will edit for the TIA wow. Each module has its own test file so TIA can skip the other ~211 atoms.

**Say**

- This is a ~10k-test e-commerce suite, not six files. Classic CI still “just run everything.”
- 15-wide and dumb still hurts: name split, no TIA, Jest single-threaded.
- Smarter Testing is what you reach for when that suite would crush a release train. Parallelism **2** is enough to show a split and the savings vs 15 busy classic nodes — not 30 mostly idle containers.

## 1:00–3:00 — Classic workflow

**Trigger** (if it is not already running from the `main` push): CircleCI UI → **Trigger Pipeline** → `run-classic: true`, `run-smarter: false`.

**Clicks**

1. Open the `classic-full-suite` workflow → job `classic-tests` (15 parallel nodes).
2. Open **Discover and run the full suite**. You should see ~212 `demo/src/**/*.test.js` files discovered, then a **name** split for this node.
3. Compare two nodes: an early-alphabet shard (`cart` / `catalog`) vs a late one (`users` / `warehouse`). The late shard has more cases per file and finishes later.
4. Open the **Tests** tab. The full suite ran.

**Audience should notice**

- Full suite, every time, regardless of what changed.
- Expected Linux wall-clock: about **4–8 minutes** (slowest name-shard; warehouse is heavier on purpose).
- This is the old pattern: `circleci tests glob` + `circleci tests split --split-by=name`. No timings, no TIA.

## 3:00–6:00 — Smarter workflow

**Trigger:** **Trigger Pipeline** → `run-classic: false`, `run-smarter: true`.

### On `main` (first run / default-branch behavior)

**Clicks**

1. Open `smarter-testing` → `smarter-tests` (2 parallel nodes).
2. In **Run smarter tests**, look for selection / analysis output — not a raw `jest` glob.
3. Open **Tests**. On `main`, Smarter Testing still **runs all tests** and **updates impact data**. That is expected. Duration may be *longer* than classic because analysis adds coverage instrumentation.

**Say**

- Default branch = build the map of “which test covers which file.”
- Feature branches = use that map to run only impacted tests.
- The wow is **not** the first `main` run.

### The TIA moment (feature branch — do this after `main` has impact data)

1. Branch off `main`.
2. Change **only** [`demo/src/pricing/quote.js`](demo/src/pricing/quote.js) — for example, tweak the `UNIT` comment or add a space you immediately revert, or change a comment on the TIA hook line. Do **not** edit `demo/src/testSupport/delay.js`, `package.json`, or `.circleci/*.yml` (`full-test-run-paths` forces a full run).
3. Push. Open the new `smarter-testing` job.

**Audience should notice**

- Log line about **Selecting tests**.
- Only `demo/src/pricing/quote.test.js` runs (**44** cases). The other ~211 test files skip.
- **Tests** tab (job level): **44 passed**, rest skipped. That is the reliable “always a hit” view — do **not** assume every container ran tests.
- One of the two nodes runs `quote.test.js`. The other **may still be idle** (“Ran 0 test atoms”). Open the **Tests** tab or the **busy** parallel index, not a random container.
- Job is a **small fraction** of classic time. Aim: **under ~90 seconds** on Linux after checkout/npm cache (often much less).
- **Timings** tab: 2 nodes share work (`dynamic-test-splitting: true`). After TIA that is one busy node vs classic’s 15 busy shards — that is the savings story.
- `max-auto-rerun: 1` is configured; you will only see a rerun if a test atom fails.

If you have no impact data yet, every test is treated as new and all of them run. Call that out; do not fake skipped tests.

## 6:00–8:00 — CLI (real commands)

Run these from the **repo root**. Do **not** pass `--local` when you want CircleCI’s stored impact graph. `--local` is a flag on `circleci testsuite` itself (not on `run` / `list-tests`) and uses a filesystem impact file instead.

Glance (10 seconds):

```bash
circleci testsuite --help
```

What would Smarter Testing select right now (fetches CircleCI impact data):

```bash
circleci testsuite list-tests "demo tests"
```

Same selection, then actually run Jest locally:

```bash
circleci testsuite run "demo tests"
```

Optional overrides (real flags): `--run-tests=all|impacted|none|default` and `--analyze-tests=all|impacted|none|default`.

Resource usage of a finished job. The argument is a **job UUID**, not a job number. Get it from `circleci workflow get` or `circleci run get --json`.

```bash
circleci run list --project gh/AwesomeCICD/awesomeci-test-splitting --branch main
circleci run get --project gh/AwesomeCICD/awesomeci-test-splitting --branch main --no-interactive
circleci workflow get WORKFLOW_UUID
circleci job resource-usage get JOB_UUID
```

Example with a placeholder UUID (replace it):

```bash
circleci job resource-usage get 0dc4d8df-8f7e-41b0-a3ef-88066a5465c1
```

`--chart separate` splits parallel executions. `--json` is available if you want numbers instead of the chart.

**Audience should notice**

- `list-tests` is the same selector CI uses, against CircleCI impact data.
- `resource-usage get` charts CPU and memory against the resource class limit. Classic’s 15 nodes stay busy; a TIA branch uses 2 nodes and one of them may sit idle.

### `--local` (mention only)

```bash
circleci testsuite --local list-tests "demo tests"
```

That reads locally stored impact data. Skip it when you are showing CircleCI’s graph.

## 8:00–9:00 — macOS (mention)

Same demo jobs, macOS executor (`xcode: "26.6.0"`, `m4pro.medium`, Node already on the image). No PHP, no Docker-in-Docker.

**Trigger Pipeline** → set `run-macos` to `true`. Workflows become `classic-full-suite-macos` and `smarter-testing-macos`. Linux workflows do not run.

**macOS parallelism is 2** (classic Linux stays **15**; smarter Linux is also **2**). macOS VMs are the bottleneck and spinning many of them would be slow and expensive. Linux classic vs smarter is the timing/savings showcase; macos is “same jobs, different executor.”

macOS VMs are slower to provision than `cimg/node`. Start this trigger only if you have time, or show a previous macOS run. Do not wait it out in a 5-minute slot.

## If something fails live

| Symptom | Likely cause |
| --- | --- |
| `circleci testsuite` not found locally | `circleci extension install testsuite` |
| Container says “Ran 0 test atoms” | Expected on the idle smarter node. Open the job **Tests** tab (44 passed / rest skipped) or the busy parallel index |
| All tests run on a feature branch | No impact data on `main` yet, or you changed `full-test-run-paths` (`.circleci/*.yml`, `demo/package.json`, `demo/jest.config.cjs`, `demo/jest.sh`) |
| Smarter job longer than classic on `main` | Analysis is doing its job; compare a later feature branch that edits only `demo/src/pricing/quote.js` |
| `resource-usage` errors | Job still running, or you passed a workflow ID / job number instead of the job UUID |
| macOS queue / long classic macos | Expected (parallelism 2 + VM provision). Do not use macos for the timing wow |
