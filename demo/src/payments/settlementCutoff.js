// Hand-written for the Smarter Testing auto-rerun demo (not generated).
"use strict";

const MARKET_CLOSE_MINUTES = 16 * 60;

function isBeforeCutoff(minutesAfterMidnight, cutoff = MARKET_CLOSE_MINUTES) {
  return minutesAfterMidnight < cutoff;
}

function isBusinessDay(dayOfWeek) {
  return dayOfWeek !== 0 && dayOfWeek !== 6;
}

// dayOfWeek: 0 = Sunday ... 6 = Saturday.
function nextBusinessDay(dayOfWeek) {
  let day = (dayOfWeek + 1) % 7;
  while (!isBusinessDay(day)) {
    day = (day + 1) % 7;
  }
  return day;
}

function tradeDay(dayOfWeek, minutesAfterMidnight) {
  if (isBusinessDay(dayOfWeek) && isBeforeCutoff(minutesAfterMidnight)) {
    return dayOfWeek;
  }
  return nextBusinessDay(dayOfWeek);
}

function settlementDay(dayOfWeek, minutesAfterMidnight, businessDays = 1) {
  let day = tradeDay(dayOfWeek, minutesAfterMidnight);
  for (let i = 0; i < businessDays; i += 1) {
    day = nextBusinessDay(day);
  }
  return day;
}

module.exports = {
  MARKET_CLOSE_MINUTES,
  isBeforeCutoff,
  isBusinessDay,
  nextBusinessDay,
  tradeDay,
  settlementDay,
};
