#!/usr/bin/env bash
# Merge Gradle's per-class JUnit XML files into one report, tagging every
# test case with the test file it came from (Gradle only records the class).
#
#   android/scripts/merge-junit.sh <gradle-test-results-dir> <junit-out>
set -euo pipefail

DIR="$1"
OUT="$2"
mkdir -p "$(dirname "${OUT}")"

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<testsuites>'
  for xml in "${DIR}"/TEST-*.xml; do
    [[ -e "${xml}" ]] || continue
    class="$(basename "${xml}" .xml)"
    class="${class#TEST-}"
    file="android/src/test/kotlin/${class//.//}.kt"
    sed -e '/^<?xml/d' \
        -e "s|<testsuite |<testsuite file=\"${file}\" |" \
        -e "s|<testcase |<testcase file=\"${file}\" |g" \
        "${xml}"
  done
  echo '</testsuites>'
} > "${OUT}"
