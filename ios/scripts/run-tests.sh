#!/usr/bin/env bash
# Run the given XCTest files with `swift test` and write a JUnit (xUnit) report.
#
#   ios/scripts/run-tests.sh <junit-out> <test-file>...
#
# Test atoms are file paths (ios/Tests/MobileCoreTests/FooTests.swift). Each file
# holds one XCTestCase class with the same name, so the file maps to a filter.
set -uo pipefail

OUT="$1"
shift
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

classes=()
for file in "$@"; do
  classes+=("$(basename "${file}" .swift)")
done
filter="^MobileCoreTests\\.($(IFS='|'; echo "${classes[*]}"))/"

log="$(mktemp)"
swift test --package-path "${ROOT}" --disable-swift-testing --filter "${filter}" 2>&1 | tee "${log}"
status=${PIPESTATUS[0]}

mkdir -p "$(dirname "${OUT}")"
"${ROOT}/scripts/xctest-to-junit.sh" < "${log}" > "${OUT}"
exit "${status}"
