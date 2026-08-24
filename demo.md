# Smarter Testing live demo (5–10 min)

Presenter script. Start here. The audience should leave knowing the difference between “run everything” and CircleCI Smarter Testing.

Smarter Testing is in **beta**. The org must be on CircleCI cloud. There is no extra product flag in this repo, but if `circleci testsuite` fails in CI, the org may still need beta access.

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

4. **Test impact analysis needs impact data first.** The default branch (`main`) must complete a `smarter-testing` run so analysis can upload coverage. A brand-new project, or a first push of this config, will run the **full** smarter suite (and look closer to classic) until that data exists.

5. Work from the repo root. `test-suites.yml` lives at `.circleci/test-suites.yml`. The demo suite is the six Jest files under `demo/` — not the large generated React suite.

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

1. Open `.circleci/config.yml`. Point at the two workflow names: `classic-full-suite` and `smarter-testing`.
2. Open `.circleci/test-suites.yml`. Point at `test-impact-analysis`, `dynamic-test-splitting`, and `max-auto-rerun`.
3. Open `demo/src/` — six tiny modules (`cart`, `pricing`, `shipping`, `inventory`, `users`, `checkout`). `checkout` imports `cart` and `pricing` on purpose.

**Say**

- Classic CI discovers every test and runs all of them.
- Smarter Testing uses the same six tests, but can skip ones that the change did not touch, split the rest across nodes, and rerun a failure once.

## 1:00–3:00 — Classic workflow

**Trigger** (if it is not already running from the `main` push): CircleCI UI → **Trigger Pipeline** → `run-classic: true`, `run-smarter: false`.

**Clicks**

1. Open the `classic-full-suite` workflow → job `classic-tests`.
2. Open the **Discover and run the full suite** step. You should see all six `demo/src/**/*.test.js` files listed.
3. Open the **Tests** tab. Every demo test ran.

**Audience should notice**

- Full suite, every time, regardless of what changed.
- Duration is the sum of the six delayed tests (~2.5s each, plus Jest).
- This is the old pattern: `circleci tests glob` + optional `circleci tests split`.

## 3:00–6:00 — Smarter workflow

**Trigger:** **Trigger Pipeline** → `run-classic: false`, `run-smarter: true`.

### On `main` (first run / default-branch behavior)

**Clicks**

1. Open `smarter-testing` → `smarter-tests` (two parallel nodes).
2. In the **Run smarter tests** step, look for selection / analysis output — not a raw `jest` glob.
3. Open **Tests**. On `main`, Smarter Testing still **runs all tests** and **updates impact data**. That is expected. Duration may be *longer* than classic because analysis adds coverage instrumentation.

**Say**

- Default branch = build the map of “which test covers which file.”
- Feature branches = use that map to run only impacted tests.

### The TIA moment (feature branch — do this after `main` has impact data)

1. Branch off `main`.
2. Change only `demo/src/pricing.js` (for example, tweak the rounding comment or a number you immediately fix).
3. Push. Open the new `smarter-testing` job.

**Audience should notice**

- Log line about **Selecting tests**.
- `pricing.test.js` and `checkout.test.js` run (`checkout` imports `pricing`).
- `cart`, `shipping`, `inventory`, `users` are skipped.
- Job is shorter than classic.
- **Timings** tab: the two nodes share work (`dynamic-test-splitting: true`).
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

Optional overrides (real flags): `--run-tests=all|impacted|none` and `--analyze-tests=all|impacted|none`.

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
- `resource-usage get` charts CPU and memory against the resource class limit.

### `--local` (mention only)

```bash
circleci testsuite --local list-tests "demo tests"
```

That reads locally stored impact data. Skip it when you are showing CircleCI’s graph.

## 8:00–9:00 — macOS (mention)

Same demo jobs, macOS executor (`xcode: "26.6.0"`, `m4pro.medium`, Node already on the image). No PHP, no Docker-in-Docker.

**Trigger Pipeline** → set `run-macos` to `true`. Workflows become `classic-full-suite-macos` and `smarter-testing-macos`. Linux workflows do not run.

macOS VMs are slower to provision than `cimg/node`. Start this trigger only if you have a minute, or show a previous macOS run.

## If something fails live

| Symptom | Likely cause |
| --- | --- |
| `circleci testsuite` not found locally | `circleci extension install testsuite` |
| All tests run on a feature branch | No impact data on `main` yet, or you changed `full-test-run-paths` (`.circleci/*.yml`, `demo/package.json`) |
| Smarter job longer than classic on `main` | Analysis is doing its job; compare a later feature branch |
| `resource-usage` errors | Job still running, or you passed a workflow ID / job number instead of the job UUID |
| macOS queue | Expected; do not wait it out in a 5-minute slot |
