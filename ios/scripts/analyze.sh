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

marker="$(mktemp)"
swift test --package-path "${ROOT}" --disable-swift-testing --enable-code-coverage \
  --filter "^MobileCoreTests\\.${class}/" >&2

# The build layout differs between SwiftPM versions (.build/debug vs
# .build/out/Products/Debug), so find this run's profile and test bundle.
profdata="$(find "${ROOT}/.build" -name '*.profdata' -newer "${marker}" -print -quit)"
bundle="$(find "${ROOT}/.build" -type d -name '*.xctest' -prune -newer "${marker}" -print -quit)"
bundle="${bundle:-$(find "${ROOT}/.build" -type d -name '*.xctest' -prune -print -quit)}"
if [[ -z "${profdata}" || -z "${bundle}" ]]; then
  echo "coverage output not found (profdata='${profdata}', bundle='${bundle}')" >&2
  find "${ROOT}/.build" \( -name '*.profdata' -o -name '*.xctest' \) >&2
  exit 1
fi

# llvm-cov lists every file linked into the test binary, executed or not. Keep
# only files with at least one executed line, with repo-relative paths.
xcrun llvm-cov export -format=lcov \
  -instr-profile "${profdata}" \
  "${bundle}/Contents/MacOS/$(basename "${bundle}" .xctest)" \
  -ignore-filename-regex='/(Tests|\.build)/' \
  | sed "s|^SF:${REPO}/|SF:|" \
  | awk 'BEGIN { RS = "end_of_record\n" }
         /(^|\n)DA:[0-9]+,[1-9]/ { printf "%send_of_record\n", $0 }' > "${OUT}"
