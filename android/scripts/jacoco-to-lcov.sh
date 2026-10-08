#!/usr/bin/env bash
# Convert a JaCoCo XML report to LCOV, one of the coverage formats
# circleci testsuite analysis reads.
#
#   android/scripts/jacoco-to-lcov.sh <jacocoTestReport.xml> <source-root>
#
# JaCoCo lists every class in the module, covered or not. Only source files with
# at least one executed line are written, otherwise every test would appear to
# depend on every file and test impact analysis could never skip anything.
set -euo pipefail

awk -v root="$2" '
  BEGIN { RS = "<" }
  function attr(name,   re) {
    re = name "=\"[^\"]*\""
    if (!match($0, re)) return ""
    return substr($0, RSTART + length(name) + 2, RLENGTH - length(name) - 3)
  }
  /^package / { pkg = attr("name") }
  /^sourcefile / { file = root "/" pkg "/" attr("name"); body = ""; hit = 0 }
  /^line / && file != "" {
    ci = attr("ci") + 0
    body = body "DA:" attr("nr") "," ci "\n"
    if (ci > 0) hit = 1
  }
  /^\/sourcefile>/ {
    if (hit) printf "SF:%s\n%send_of_record\n", file, body
    file = ""
  }
' "$1"
