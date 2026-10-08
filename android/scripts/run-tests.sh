#!/usr/bin/env bash
# Run the given JUnit test files through Gradle and write one JUnit XML report.
#
#   android/scripts/run-tests.sh <junit-out> <test-file>...
#
# Test atoms are file paths (android/src/test/kotlin/.../FooTest.kt) so that
# circleci testsuite can map results, timings and coverage back to files.
set -uo pipefail

OUT="$1"
shift
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

filters=()
for file in "$@"; do
  class="${file#android/src/test/kotlin/}"
  class="${class%.kt}"
  filters+=(--tests "${class//\//.}")
done

rm -rf "${ROOT}/build/test-results/test"
gradle -p "${ROOT}" --daemon --console=plain test --rerun "${filters[@]}"
status=$?

"${ROOT}/scripts/merge-junit.sh" "${ROOT}/build/test-results/test" "${OUT}"
exit "${status}"
