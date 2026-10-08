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

raw="$(mktemp -d)/xunit.xml"
swift test --package-path "${ROOT}" --disable-swift-testing --filter "${filter}" --xunit-output "${raw}"
status=$?

# swift test records only the class name; add the file each case came from.
mkdir -p "$(dirname "${OUT}")"
[[ -f "${raw}" ]] || exit "${status}"
sed -E 's|<testcase classname="MobileCoreTests\.([A-Za-z0-9_]+)"|<testcase file="ios/Tests/MobileCoreTests/\1.swift" classname="MobileCoreTests.\1"|g' \
  "${raw}" > "${OUT}"
exit "${status}"
