# Smarter Testing live demo (5–10 min)

Presenter script. Start here. The audience should leave knowing why Smarter Testing is what you use when a huge suite would otherwise crush you.

Smarter Testing is in **beta**. The org must be on CircleCI cloud. There is no extra product flag in this repo, but if `circleci testsuite` fails in CI, the org may still need beta access.

## Scale (what you are showing)

| | Classic `classic-full-suite` | Smarter `smarter-testing` |
| --- | --- | --- |
| Tests | **9,716** cases in **212** files | Same suite |
| Parallelism | **15** (fixed) | **Dynamic**, 1–15 (sized from the TIA selection) |
| Split | `circleci tests split --split-by=name` (not timings) | Dynamic test splitting + timing data |
| Selection | Always the **full** suite. No TIA. | TIA on feature branches |
| Jest | `--runInBand`, `DEMO_TEST_DELAY_MS=300` | `--maxWorkers=2`, `DEMO_TEST_DELAY_MS=15` |

Smarter uses **dynamic parallelism**: an upstream `smarter-list-tests` job runs `circleci testsuite list-tests "demo tests" --key=...` (TIA selection, no tests run), and CircleCI sizes `smarter-tests` from the selected atoms' timings via the `experimental.dynamic-parallelism` stanza (`min: 1`, `max: 15`). Full suite on `main` → 15 nodes, same as classic. A feature branch that only touches `quote.js` → **1 node**, no idle containers. Docs: [Set parallelism dynamically](https://circleci.com/docs/guides/test/set-parallelism-dynamically/). The feature is experimental; the stanza syntax will change.

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

4. **Test impact analysis needs impact data first. This project already has it.** The impact data was last rebuilt from scratch by [pipeline 274](https://app.circleci.com/pipelines/gh/AwesomeCICD/awesomeci-test-splitting/274/workflows/2a7bb326-3445-4ba9-94a8-3030e4ea18c4/jobs/533/parallel-runs/12) (version 274). Confirm it is there before the room:

   ```bash
   circleci testsuite impact --file=demo/src/pricing/quote.js
   # → demo/src/pricing/quote.test.js
   ```

   If that prints nothing (new project, or data lost), rebuild it: see **Rebuild the impact data** under [How to trigger pipelines](#how-to-trigger-pipelines).

5. Work from the repo root. `test-suites.yml` lives at `.circleci/test-suites.yml`. The demo path is the generated Jest suite under `demo/src/<domain>/`. Do not wire `react/` into these workflows.

## How to trigger pipelines

| What you want | How |
| --- | --- |
| Default (Linux, both workflows) | Push to `main`, or **Trigger Pipeline** with defaults |
| Classic only | **Trigger Pipeline** → `run-classic: true`, `run-smarter: false` |
| Smarter only | **Trigger Pipeline** → `run-classic: false`, `run-smarter: true` |
| Same jobs on macOS | **Trigger Pipeline** → `run-macos: true` (Linux workflows are skipped) |
| Rebuild the impact data | **Trigger Pipeline** on `main` → `run-classic: false`, `run-smarter: true`, `analyze-tests: all` |

Project slug if you need it: `gh/AwesomeCICD/awesomeci-test-splitting`.

From the terminal, do **not** use `circleci pipeline run --param`: it sends every value as a string, and the boolean parameters reject `"true"` / `"false"` (the pipeline errors with no workflows). Send a JSON body instead:

```bash
circleci api api/v2/project/gh/AwesomeCICD/awesomeci-test-splitting/pipeline/run -X POST \
  -d '{"definition_id":"ab8e0572-7f57-4679-9c74-25593861f584","config":{"branch":"main"},"checkout":{"branch":"main"},"parameters":{"run-classic":false,"run-smarter":true,"analyze-tests":"all"}}'
```

Drop `"analyze-tests":"all"` for a normal smarter-only run.

## 0:00–1:00 — Setup and the contrast

**Clicks**

1. Open `.circleci/config.yml`. Point at `classic-full-suite` (parallelism **15**, fixed) vs `smarter-testing` (`smarter-list-tests` → `smarter-tests`), and the `experimental.dynamic-parallelism` stanza at the bottom (`min: 1`, `max: 15`).
2. Open `.circleci/test-suites.yml`. Point at `test-impact-analysis`, `dynamic-test-splitting`, and `max-auto-rerun`. Classic does **not** use this file.
3. Open `demo/src/pricing/quote.js`. That is the file you will edit for the TIA wow. Each module has its own test file so TIA can skip the other ~211 atoms.

**Say**

- This is a ~10k-test e-commerce suite, not six files. Classic CI still “just run everything.”
- 15-wide and dumb still hurts: name split, no TIA, Jest single-threaded.
- Smarter Testing is what you reach for when that suite would crush a release train. You don’t pick a parallelism number: Smarter Testing sizes the job from what it’s actually going to run.

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

### On `main` (default-branch behavior)

**Clicks**

1. Open `smarter-testing`. First `smarter-list-tests` runs (one node, lists the selection). Then `smarter-tests` starts with up to **15** parallel nodes — on `main` it’s the full suite, so expect `max`. **Parallel runs** on the Steps tab shows the count.
2. In **Run smarter tests**, find the **primary node**: every node’s log starts with `Primary node set to N`. Open node N — only that one prints the discovery and selection lines. N changes from run to run.
3. Open **Tests**. On `main`, Smarter Testing **runs all tests** (9,716) and keeps the impact data current.

A normal `main` run is fast (~50s for the workflow) because the impact data already exists. Every node logs `Analyzed 0 tests`: by default `main` only re-analyzes tests whose own code or covered files changed, and nothing did. That is expected, not broken.

### Show the impact data being built (pre-recorded — do not run live)

Pull up [pipeline 274 → `smarter-tests` (job 533) → parallel run 12](https://app.circleci.com/pipelines/gh/AwesomeCICD/awesomeci-test-splitting/274/workflows/2a7bb326-3445-4ba9-94a8-3030e4ea18c4/jobs/533/parallel-runs/12), step **Run smarter tests**. That run was triggered with `analyze-tests: all`, which rebuilds the impact data from scratch.

On node 12 (the primary for that run), point at:

```
Discovered 212 test atoms
Queuing 212 test atoms for running
Queuing 212 test atoms for analysis      ← every test file re-run with coverage
Analyzed 14 tests in 27.558s
Patching test impact data version: 274
Updated test impact data
```

Then open any other node: each logs `Analyzed 12–16 tests in ~26–30s`. Analysis was spread across all 15 nodes (212 total), so the full rebuild added ~30s instead of ~7 minutes on one node. Compare the normal run above: `Analyzed 0 tests`.

**Say**

- Analysis re-runs each test file with coverage to record which source files it touches. That is the impact data: a list of files with content hashes, and for each test file, the files it covers.
- `main` builds and maintains that data. Feature branches use it to run only impacted tests.
- The wow is **not** the `main` run — it is the feature branch next.

The primary-node behavior and the spread of analysis across nodes come from these job logs; the docs don’t describe them. Present them as “here’s what the logs show.”

### The TIA moment (feature branch — do this after `main` has impact data)

1. Branch off `main`.
2. Show what the impact data predicts, before you push:

   ```bash
   circleci testsuite impact --file=demo/src/pricing/quote.js
   # → demo/src/pricing/quote.test.js
   ```

   “According to the impact data, this file only affects one test file. Watch CI run exactly that.”
3. Change **only** [`demo/src/pricing/quote.js`](demo/src/pricing/quote.js) — for example, tweak the `UNIT` comment or add a space you immediately revert, or change a comment on the TIA hook line. Do **not** edit `package.json` or `.circleci/*.yml` (`full-test-run-paths` forces a full run), or `demo/src/testSupport/delay.js` — every test file covers it, so `circleci testsuite impact --file=demo/src/testSupport/delay.js` lists all 212 and editing it selects the full suite.
4. Push. Open the new `smarter-testing` job.

**Audience should notice**

- Log line about **Selecting tests**.
- Only `demo/src/pricing/quote.test.js` runs (**44** cases). The other ~211 test files skip.
- **Tests** tab (job level): **44 passed**, rest skipped. That is the reliable “always a hit” view — do **not** assume every container ran tests.
- `smarter-list-tests` shows the single selected atom. `smarter-tests` then starts with **1** parallel node (vs 15 on `main`) — check **Parallel runs** on the Steps tab and the `Dynamic parallelism picked 1 node(s)` log line. No idle containers.
- Job is a **small fraction** of classic time. Aim: **under ~90 seconds** on Linux after checkout/npm cache (often much less).
- Same config, same `max: 15`: the full suite got 15 nodes, this branch got 1. That is the savings story — parallelism follows the selected work instead of a hard-coded number.
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

Look inside the impact data CI uses (`impact` is marked experimental):

```bash
circleci testsuite impact --test=demo/src/pricing/quote.test.js   # files this test covers
circleci testsuite impact --file=demo/src/pricing/quote.js        # tests this file affects
circleci testsuite impact --version=274 --file=demo/src/pricing/quote.js   # a specific stored version
```

Run `circleci testsuite impact` with no flags in a real terminal for an interactive explorer (`--sort=impact` puts the most connected files first).

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
- `resource-usage get` charts CPU and memory against the resource class limit. Classic’s 15 nodes stay busy; a TIA branch uses 1 node.
- `list-tests --key=...` is the same command CI runs upstream to size `smarter-tests`. Locally you can omit `--key`.

### `--local` (mention only)

```bash
circleci testsuite --local list-tests "demo tests"
```

That reads locally stored impact data. Skip it when you are showing CircleCI’s graph.

### Where the impact data lives

- **CircleCI stores it per project**, under the suite’s impact key (`default` here — do not change it). It is versioned; each `main` run logs `Patching test impact data version: N`.
- **No web app page shows it** (none we know of, and the docs mention none). Show it with `circleci testsuite impact`. The job log (building it) and the **Tests** tab (using it) are the UI evidence.
- **`.circleci/impact-default.json` is not the CI copy.** If you have one, it is an untracked local file written by `--local` runs (the sidecar demo). CI never reads it; do not commit it. It has the same format, so it is fine to open for “here’s what the data looks like” — say it is a local copy.
- Backstage only: the CLI reads `GET /api/v2/projects/{project-id}/impact-analysis` (`circleci api api/v2/projects/ace12b80-51cb-4fad-857f-0ee6b874e251/impact-analysis | jq .`). That endpoint is undocumented and may change; do not show it to customers.

## 8:00–9:00 — macOS (mention)

Same demo jobs, macOS executor (`xcode: "26.6.0"`, `m4pro.medium`, Node already on the image). No PHP, no Docker-in-Docker.

**Trigger Pipeline** → set `run-macos` to `true`. Workflows become `classic-full-suite-macos` and `smarter-testing-macos`. Linux workflows do not run.

**macOS parallelism is capped at 2** (classic Linux stays **15**; smarter Linux is dynamic 1–15, smarter macOS is dynamic 1–2). macOS VMs are the bottleneck and spinning many of them would be slow and expensive. Linux classic vs smarter is the timing/savings showcase; macos is “same jobs, different executor.”

macOS VMs are slower to provision than `cimg/node`. Start this trigger only if you have time, or show a previous macOS run. Do not wait it out in a 5-minute slot.

## If something fails live

| Symptom | Likely cause |
| --- | --- |
| `circleci testsuite` not found locally | `circleci extension install testsuite` |
| `smarter-tests` ran 15 nodes on a feature branch | TIA selected the full suite (no impact data, or a `full-test-run-paths` change), or there are no timings yet — run the suite once on `main` first |
| `smarter-tests` ignored dynamic parallelism and used its config `parallelism` | `list-tests` failed or `--key` doesn’t match the stanza `key`; this is the documented fallback |
| All tests run on a feature branch | No impact data (`circleci testsuite impact --file=demo/src/pricing/quote.js` prints nothing), you changed `full-test-run-paths` (`.circleci/*.yml`, `demo/package.json`, `demo/jest.config.cjs`, `demo/jest.sh`), or you edited `demo/src/testSupport/delay.js` (every test covers it) |
| `main` shows `Analyzed 0 tests` / `Selected 0 test atoms, Skipped 212` | Expected. Impact data already exists and nothing changed; `main` still runs all tests. To show the data being built, use pipeline 274 |
| Smarter job much slower on `main` | Analysis is re-running tests with coverage (an `analyze-tests: all` run, or many changed files). Compare a feature branch that edits only `demo/src/pricing/quote.js` |
| Pipeline errors with no workflows: `expected type: boolean, actual value: "false" (type string)` | Triggered with `circleci pipeline run --param`, which sends strings. Use the UI or the `circleci api` JSON body under [How to trigger pipelines](#how-to-trigger-pipelines) |
| `resource-usage` errors | Job still running, or you passed a workflow ID / job number instead of the job UUID |
| macOS queue / long classic macos | Expected (max parallelism 2 + VM provision). Do not use macos for the timing wow |
