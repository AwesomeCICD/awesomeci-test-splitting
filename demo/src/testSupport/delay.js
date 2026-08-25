"use strict";

function delay(ms = Number(process.env.DEMO_TEST_DELAY_MS || 0)) {
  if (!ms) {
    return Promise.resolve();
  }
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports = { delay };
