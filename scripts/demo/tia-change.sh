#!/usr/bin/env bash
# Make a one-module change on a fresh short-lived branch so test impact analysis
# selects only that module's test file. Never touches main.
#
#   scripts/demo/tia-change.sh                              # demo/src/tax/withholding.js
#   scripts/demo/tia-change.sh demo/src/pricing/quote.js
#   bash /path/to/repo/scripts/demo/tia-change.sh /path/to/repo/demo/src/pricing/quote.js
#   NO_PUSH=1 scripts/demo/tia-change.sh                    # commit locally, do not push
#   BASE_BRANCH=some-branch scripts/demo/tia-change.sh      # branch off something else
#   BRANCH=vijay-2026-10-08-demo-tia-withholding scripts/demo/tia-change.sh   # fixed branch name
#
# The edit is a behaviour-preserving refactor of the module's fee path, so the
# selected tests still pass. If the module was already refactored, a dated
# comment is appended instead (a comment still changes the file hash).
#
# Works from any directory: the repo is found from this script's location, and
# the module may be an absolute path or a path relative to the repo root.
set -euo pipefail

BASE_BRANCH="${BASE_BRANCH:-vijay-2026-10-08-demo}"
MODULE="${1:-demo/src/tax/withholding.js}"
APP_URL="https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting"

ROOT="$(cd "$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)" && pwd -P)"

if [[ "${MODULE}" == /* ]]; then
  if [[ ! -f "${MODULE}" ]]; then
    echo "No such file: ${MODULE}" >&2
    exit 1
  fi
  abs="$(cd "$(dirname "${MODULE}")" && pwd -P)/$(basename "${MODULE}")"
  if [[ "${abs}" != "${ROOT}/"* ]]; then
    echo "${MODULE} is outside the repo (${ROOT})." >&2
    exit 1
  fi
  MODULE="${abs#"${ROOT}/"}"
fi

cd "${ROOT}"

if [[ ! -f "${MODULE}" || "${MODULE}" == *.test.js ]]; then
  echo "Not a source module: ${MODULE}" >&2
  exit 1
fi
TEST_FILE="${MODULE%.js}.test.js"
if [[ ! -f "${TEST_FILE}" ]]; then
  echo "No sibling test file for ${MODULE} (expected ${TEST_FILE})" >&2
  exit 1
fi
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree has uncommitted changes. Commit or stash them first." >&2
  exit 1
fi

NAME="$(basename "${MODULE}" .js)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BRANCH="${BRANCH:-${BASE_BRANCH}-tia-${NAME}-${STAMP}}"

git fetch --quiet origin "${BASE_BRANCH}"
git switch --quiet --no-track -c "${BRANCH}" "origin/${BASE_BRANCH}"

node - "${MODULE}" "${NAME}" "${STAMP}" <<'EOF'
const fs = require("fs");
const [file, name, stamp] = process.argv.slice(2);
const src = fs.readFileSync(file, "utf8");
const before = `  return ${name}(amount, factor) + fee;`;
const after = `  const base = ${name}(amount, factor);\n  return base + fee;`;
const next = src.includes(before)
  ? src.replace(before, after)
  : `${src}// TIA demo edit ${stamp}\n`;
fs.writeFileSync(file, next);
EOF

git add "${MODULE}"
git commit --quiet -m "Refactor the ${NAME} fee path (Smarter Testing TIA demo)"
echo "Created ${BRANCH} with one change to ${MODULE}:"
git --no-pager show --stat --format='  %h %s' HEAD

if [[ "${NO_PUSH:-}" == "1" ]]; then
  echo "NO_PUSH=1: not pushing. Push later with: git -C ${ROOT} push -u origin ${BRANCH}"
else
  git push --quiet -u origin "${BRANCH}"
  echo
  echo "Pushed. Watch the pipeline:"
  echo "  ${APP_URL}?branch=$(node -e 'process.stdout.write(encodeURIComponent(process.argv[1]))' "${BRANCH}")"
  echo "  circleci run watch --branch ${BRANCH}"
fi

echo
echo "Expected in the smarter-testing job: only ${TEST_FILE} is selected; every other test atom is skipped."
echo "classic-full-suite still runs all 212 files on 15 nodes."
echo "Go back with: git -C ${ROOT} switch ${BASE_BRANCH}"
