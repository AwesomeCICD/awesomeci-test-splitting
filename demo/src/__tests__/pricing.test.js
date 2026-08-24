const { applyDiscount, tax } = require("../pricing");

const delayMs = Number(process.env.DEMO_TEST_DELAY_MS || 2500);
const delay = (ms = delayMs) => new Promise((resolve) => setTimeout(resolve, ms));

test("applies a percent discount and tax", async () => {
  await delay();
  expect(applyDiscount(100, 10)).toBe(90);
  expect(tax(90, 0.08)).toBe(7.2);
});
