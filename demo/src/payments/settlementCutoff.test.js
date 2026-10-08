// Hand-written for the Smarter Testing auto-rerun demo (not generated).
//
// "reads the cutoff from a warm calendar cache" is deliberately flaky: the
// first attempt in a fresh container fails, as if a cold cache timed out, and
// any retry in the same container passes. With max-auto-rerun in
// .circleci/test-suites.yml, the smarter-testing job retries it and goes green;
// classic-full-suite has no retry and goes red.
// Locally, reset with: rm -f "$TMPDIR"/settlement-calendar-warm-*
"use strict";

const fs = require("fs");
const os = require("os");
const path = require("path");
const {
  MARKET_CLOSE_MINUTES,
  isBeforeCutoff,
  nextBusinessDay,
  tradeDay,
  settlementDay,
} = require("./settlementCutoff");
const { delay } = require("../testSupport/delay");

const MON = 1;
const FRI = 5;
const SAT = 6;
const SUN = 0;

const warmMarker = path.join(
  os.tmpdir(),
  `settlement-calendar-warm-${process.env.CIRCLE_WORKFLOW_JOB_ID || "local"}`,
);

function calendarCacheIsWarm() {
  if (fs.existsSync(warmMarker)) {
    return true;
  }
  fs.writeFileSync(warmMarker, new Date().toISOString());
  return false;
}

test("accepts a contribution submitted before market close", async () => {
  await delay();
  expect(isBeforeCutoff(15 * 60 + 59)).toBe(true);
});

test("rejects a contribution submitted at market close", async () => {
  await delay();
  expect(isBeforeCutoff(MARKET_CLOSE_MINUTES)).toBe(false);
});

test("rolls a Friday after-close order to Monday", async () => {
  await delay();
  expect(tradeDay(FRI, 17 * 60)).toBe(MON);
});

test("rolls a weekend order to Monday", async () => {
  await delay();
  expect(tradeDay(SAT, 10 * 60)).toBe(MON);
  expect(tradeDay(SUN, 10 * 60)).toBe(MON);
});

test("skips the weekend when finding the next business day", async () => {
  await delay();
  expect(nextBusinessDay(FRI)).toBe(MON);
});

test("settles a Monday before-close trade on Tuesday (T+1)", async () => {
  await delay();
  expect(settlementDay(MON, 9 * 60)).toBe(2);
});

test("settles a Friday before-close trade on Monday (T+1)", async () => {
  await delay();
  expect(settlementDay(FRI, 9 * 60)).toBe(MON);
});

test("reads the cutoff from a warm calendar cache", async () => {
  await delay();
  expect(calendarCacheIsWarm()).toBe(true);
  expect(isBeforeCutoff(12 * 60)).toBe(true);
});
