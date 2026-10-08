#!/usr/bin/env bash
# Run one XCTest file with code coverage and write it as LCOV, for
# circleci testsuite analysis (one test atom at a time).
#
#   ios/scripts/analyze.sh <test-file> <lcov-out>
set -euo pipefail

ATOM="$1"
OUT="$2"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$(cd "${ROOT}/.." && pwd)"
class="$(basename "${ATOM}" .swift)"

bin="$(swift build --package-path "${ROOT}" --show-bin-path)"
rm -rf "${bin}/codecov"
swift test --package-path "${ROOT}" --disable-swift-testing --enable-code-coverage \
  --filter "^MobileCoreTests\\.${class}/" >&2

# llvm-cov lists every file linked into the test binary, executed or not. Keep
# only files with at least one executed line, with repo-relative paths.
xcrun llvm-cov export -format=lcov \
  -instr-profile "${bin}/codecov/default.profdata" \
  "${bin}/MobileCorePackageTests.xctest/Contents/MacOS/MobileCorePackageTests" \
  -ignore-filename-regex='/(Tests|\.build)/' \
  | sed "s|^SF:${REPO}/|SF:|" \
  | awk 'BEGIN { RS = "end_of_record\n" }
         /(^|\n)DA:[0-9]+,[1-9]/ { printf "%send_of_record\n", $0 }' > "${OUT}"
