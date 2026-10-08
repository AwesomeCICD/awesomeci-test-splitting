#!/usr/bin/env bash
# Start a pipeline run on a branch from the CLI, without pushing.
#
#   scripts/demo/trigger-run.sh <branch> [param=value ...]
#   scripts/demo/trigger-run.sh vijay-2026-10-08-demo-tia-withholding run-classic=false
#
# Works from any directory. It reads no files and runs no git commands; the
# branch is resolved by CircleCI, so it doesn't need to exist locally.
#
# Calls POST /api/v3/runs (https://circleci.com/docs/api/v3) through `circleci api`.
# It names the project's GitHub App pipeline definition explicitly: plain
# `circleci run trigger` picks the implicit OAuth definition, whose SSH checkout
# fails on this project with "Permission denied (publickey)".
set -euo pipefail

PIPELINE_ID="ab8e0572-7f57-4679-9c74-25593861f584"   # gh-app-pipeline (default)
APP_URL="https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting"

BRANCH="${1:?usage: trigger-run.sh <branch> [param=value ...]}"
shift

params="{}"
for pair in "$@"; do
  key="${pair%%=*}"
  value="${pair#*=}"
  params="$(jq -c --arg k "${key}" --argjson v "${value}" '. + {($k): $v}' <<<"${params}" 2>/dev/null \
    || jq -c --arg k "${key}" --arg v "${value}" '. + {($k): $v}' <<<"${params}")"
done

payload="$(jq -n --arg b "${BRANCH}" --arg p "${PIPELINE_ID}" --argjson params "${params}" '{
  data: {
    attributes: { checkout: { branch: $b }, config: { branch: $b }, parameters: $params },
    references: { pipeline: { id: $p } }
  }
}')"

run_id="$(circleci api runs -X POST -d "${payload}" --jq '.data.id')"
echo "Started run ${run_id} on ${BRANCH}"
echo "  ${APP_URL}?branch=$(jq -rn --arg b "${BRANCH}" '$b|@uri')"
echo "  circleci run watch --branch ${BRANCH}"
