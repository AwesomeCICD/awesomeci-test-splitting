#!/usr/bin/env bash
# Make a one-module change on a fresh short-lived branch so test impact analysis
# selects only that module's test file. Never touches main.
#
#   scripts/demo/tia-change.sh                              # demo/src/tax/withholding.js
#   scripts/demo/tia-change.sh demo/src/pricing/quote.js
#   NO_PUSH=1 scripts/demo/tia-change.sh                    # commit locally, do not push
#   BASE_BRANCH=some-branch scripts/demo/tia-change.sh      # branch off something else
#   BRANCH=vijay-2026-10-08-demo-tia-withholding scripts/demo/tia-change.sh   # fixed branch name
#
# The edit is a behaviour-preserving refactor of the module's fee path, so the
# selected tests still pass. If the module was already refactored, a dated
# comment is appended instead (a comment still changes the file hash).
set -euo pipefail

BASE_BRANCH="${BASE_BRANCH:-vijay-2026-10-08-demo}"
MODULE="${1:-demo/src/tax/withholding.js}"
APP_URL="https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting"

cd "$(git rev-parse --show-toplevel)"

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
  echo "NO_PUSH=1: not pushing. Push later with: git push -u origin ${BRANCH}"
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
echo "Go back with: git switch ${BASE_BRANCH}"
