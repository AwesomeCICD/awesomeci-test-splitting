const { shippingCost } = require("../shipping");

const delayMs = Number(process.env.DEMO_TEST_DELAY_MS || 2500);
const delay = (ms = delayMs) => new Promise((resolve) => setTimeout(resolve, ms));

test("charges more for remote zones", async () => {
  await delay();
  expect(shippingCost(2, "local")).toBe(9);
  expect(shippingCost(2, "remote")).toBe(19);
});
