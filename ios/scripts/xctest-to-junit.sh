#!/usr/bin/env bash
# Build a JUnit XML report from XCTest console output (stdin), with a file=
# attribute per test case so circleci testsuite can map results to test files.
#
#   swift test ... 2>&1 | ios/scripts/xctest-to-junit.sh > junit.xml
#
# `swift test --xunit-output` is not written by every SwiftPM version (Xcode 27's
# skips it for XCTest-only runs), while these console lines are stable:
#   Test Case '-[MobileCoreTests.FooTests testBar]' passed (0.001 seconds).
#   /path/FooTests.swift:12: error: -[MobileCoreTests.FooTests testBar] : XCTAssertEqual failed ...
set -euo pipefail

awk '
  function esc(s) {
    gsub(/&/, "\\&amp;", s); gsub(/</, "\\&lt;", s); gsub(/>/, "\\&gt;", s); gsub(/"/, "\\&quot;", s)
    return s
  }
  function test_id(line,   s) {
    if (!match(line, /\[MobileCoreTests\.[A-Za-z0-9_]+ [A-Za-z0-9_]+\]/)) return ""
    return substr(line, RSTART + 17, RLENGTH - 18)
  }
  / error: -\[MobileCoreTests\./ {
    id = test_id($0)
    msg = $0
    sub(/^.* error: -\[[^]]*\] : /, "", msg)
    errors[id] = (id in errors) ? errors[id] "; " msg : msg
    next
  }
  /^Test Case .-\[MobileCoreTests\..*\]. (passed|failed|skipped) \(/ {
    id = test_id($0)
    split(id, part, " ")
    match($0, /\([0-9.]+ seconds\)/)
    time = substr($0, RSTART + 1, RLENGTH - 10)
    file = "ios/Tests/MobileCoreTests/" part[1] ".swift"
    tests++
    body = body sprintf("    <testcase file=\"%s\" classname=\"MobileCoreTests.%s\" name=\"%s\" time=\"%s\"", file, part[1], part[2], time)
    if ($0 ~ /\]. failed \(/) {
      failures++
      body = body sprintf(">\n      <failure message=\"%s\"/>\n    </testcase>\n", esc(errors[id] ? errors[id] : "failed"))
    } else if ($0 ~ /\]. skipped \(/) {
      skipped++
      body = body ">\n      <skipped/>\n    </testcase>\n"
    } else {
      body = body "/>\n"
    }
  }
  END {
    print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    print "<testsuites>"
    printf "  <testsuite name=\"MobileCoreTests\" tests=\"%d\" failures=\"%d\" skipped=\"%d\">\n", tests, failures, skipped
    printf "%s", body
    print "  </testsuite>"
    print "</testsuites>"
  }
'
