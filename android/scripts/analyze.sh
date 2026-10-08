#!/usr/bin/env bash
# Run one test file with JaCoCo and write its coverage as LCOV, for
# circleci testsuite analysis (one test atom at a time).
#
#   android/scripts/analyze.sh <test-file> <lcov-out>
set -euo pipefail

ATOM="$1"
OUT="$2"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

class="${ATOM#android/src/test/kotlin/}"
class="${class%.kt}"

rm -f "${ROOT}/build/jacoco/test.exec"
gradle -p "${ROOT}" --daemon --quiet test --rerun --tests "${class//\//.}" jacocoTestReport >&2

"${ROOT}/scripts/jacoco-to-lcov.sh" \
  "${ROOT}/build/reports/jacoco/test/jacocoTestReport.xml" \
  android/src/main/kotlin > "${OUT}"
