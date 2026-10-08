#!/usr/bin/env node
// Summarise demo runs (duration, parallelism, tests, credits) from CircleCI API v3.
//
//   CIRCLE_TOKEN=... node scripts/demo/collect-numbers.mjs <run-id> [<run-id> ...]
//   CIRCLE_TOKEN=... node scripts/demo/collect-numbers.mjs --branch vijay-2026-10-08-demo
//   add --json for machine-readable output
//
// Endpoints (https://circleci.com/docs/api/v3):
//   GET  /api/v3/runs/:id
//   GET  /api/v3/workflows?filter[run_id]=
//   GET  /api/v3/jobs?filter[workflow_id]=
//   GET  /api/v3/jobs/:id
//   GET  /api/v3/jobs/:id/tests            (JSON Lines)
//   POST /api/v3/analysis/charges          (experimental; credits per workflow)
// --branch resolves the latest run with `circleci run list`, so the CLI must be logged in.

import { execFileSync } from "node:child_process";

const BASE = "https://circleci.com/api/v3";
const PROJECT_SLUG = "gh/AwesomeCICD/awesomeci-test-splitting";
const APP_URL = "https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting";
const TEST_STEPS = [
  "Run smarter tests",
  "Discover and run the full suite",
  "Run Android unit tests",
  "Run iOS unit tests",
];

const token = process.env.CIRCLE_TOKEN;
if (!token) {
  console.error("CIRCLE_TOKEN is not set.");
  process.exit(1);
}

const args = process.argv.slice(2);
const asJson = args.includes("--json");
const runIds = [];
for (let i = 0; i < args.length; i += 1) {
  if (args[i] === "--json") continue;
  if (args[i] === "--branch") {
    const branch = args[(i += 1)];
    const out = execFileSync(
      "circleci",
      ["run", "list", "--project", PROJECT_SLUG, "--branch", branch, "--limit", "1", "--json"],
      { encoding: "utf8" },
    );
    const [latest] = JSON.parse(out);
    if (!latest) {
      console.error(`No runs found for branch ${branch}.`);
      process.exit(1);
    }
    runIds.push(latest.id);
    continue;
  }
  runIds.push(args[i]);
}
if (runIds.length === 0) {
  console.error("Usage: collect-numbers.mjs [--json] (--branch <name> | <run-id>...)");
  process.exit(1);
}

async function api(path, { method = "GET", body, raw = false } = {}) {
  const res = await fetch(`${BASE}${path}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: "application/json",
      ...(body ? { "Content-Type": "application/json" } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (!res.ok) {
    throw new Error(`${method} ${path} -> ${res.status} ${await res.text()}`);
  }
  return raw ? res.text() : res.json();
}

const seconds = (from, to) => (from && to ? (Date.parse(to) - Date.parse(from)) / 1000 : null);
const fmt = (s) => (s == null ? "-" : s >= 60 ? `${Math.floor(s / 60)}m ${Math.round(s % 60)}s` : `${s.toFixed(1)}s`);

async function credits(workflow) {
  const from = new Date(Date.parse(workflow.created_at) - 10 * 60_000).toISOString();
  const to = new Date(Date.parse(workflow.ended_at ?? new Date().toISOString()) + 60 * 60_000).toISOString();
  try {
    const res = await api("/analysis/charges", {
      method: "POST",
      body: {
        analysis: "charge.workflow",
        scope: { project_ids: [workflow.project_id], from, to },
        filter: `workflow.id == "${workflow.id}"`,
        page: { limit: 20 },
      },
    });
    return res.data.reduce((sum, row) => sum + row.attributes.credits, 0);
  } catch {
    return null;
  }
}

async function jobSummary(jobId) {
  const job = (await api(`/jobs/${jobId}`)).data.attributes;
  const executions = job.parallel_executions ?? [];
  const testStepSeconds = executions.map((exec) => {
    const step = exec.steps.find((s) => TEST_STEPS.includes(s.name));
    return step ? seconds(step.started_at, step.ended_at) : null;
  });
  const lines = (await api(`/jobs/${jobId}/tests`, { raw: true })).split("\n").filter(Boolean);
  const byResult = {};
  const files = new Set();
  for (const line of lines) {
    const t = JSON.parse(line);
    byResult[t.result] = (byResult[t.result] ?? 0) + 1;
    if (t.file) files.add(t.file);
  }
  const known = testStepSeconds.filter((s) => s != null);
  return {
    name: job.name,
    outcome: job.outcome,
    duration_s: seconds(job.started_at, job.ended_at),
    parallelism: executions.length,
    test_step_s: { min: known.length ? Math.min(...known) : null, max: known.length ? Math.max(...known) : null },
    tests: lines.length,
    test_files: files.size,
    results: byResult,
  };
}

const report = [];
for (const runId of runIds) {
  const run = (await api(`/runs/${runId}`)).data;
  const vcs = run.references?.event?.attributes?.vcs ?? {};
  const workflows = (await api(`/workflows?filter[run_id]=${runId}`)).data;
  const entry = {
    run_id: runId,
    number: run.attributes.number,
    branch: vcs.branch,
    revision: vcs.revision?.slice(0, 7),
    subject: vcs.commit?.subject?.split("\n")[0],
    workflows: [],
  };
  for (const wf of workflows) {
    const w = {
      id: wf.id,
      project_id: wf.references.project.id,
      name: wf.attributes.name,
      outcome: wf.attributes.outcome ?? wf.attributes.phase,
      created_at: wf.attributes.created_at,
      ended_at: wf.attributes.ended_at,
    };
    const jobs = (await api(`/jobs?filter[workflow_id]=${wf.id}`)).data;
    entry.workflows.push({
      name: w.name,
      outcome: w.outcome,
      duration_s: seconds(w.created_at, w.ended_at),
      credits: w.ended_at ? await credits(w) : null,
      url: `${APP_URL}/${entry.number}/workflows/${wf.id}`,
      jobs: await Promise.all(jobs.map((j) => jobSummary(j.id))),
    });
  }
  report.push(entry);
}

if (asJson) {
  console.log(JSON.stringify(report, null, 2));
  process.exit(0);
}

for (const r of report) {
  console.log(`\n## Run ${r.number} on ${r.branch} @ ${r.revision} — ${r.subject}`);
  console.log("| Workflow | Outcome | Wall clock | Nodes | Test step per node | Tests | Files | Credits |");
  console.log("| --- | --- | --- | --- | --- | --- | --- | --- |");
  for (const w of r.workflows) {
    for (const j of w.jobs) {
      const step = j.test_step_s.min == null ? "-" : `${fmt(j.test_step_s.min)} to ${fmt(j.test_step_s.max)}`;
      const results = Object.entries(j.results).map(([k, v]) => `${v} ${k}`).join(", ") || "0";
      console.log(
        `| [${w.name}](${w.url}) | ${w.outcome} | ${fmt(w.duration_s)} | ${j.parallelism} | ${step} | ${results} | ${j.test_files} | ${w.credits ?? "-"} |`,
      );
    }
  }
}
