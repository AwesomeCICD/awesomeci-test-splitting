const { checkoutTotal } = require("../checkout");

const delayMs = Number(process.env.DEMO_TEST_DELAY_MS || 2500);
const delay = (ms = delayMs) => new Promise((resolve) => setTimeout(resolve, ms));

test("checks out a discounted cart with tax", async () => {
  await delay();
  const cart = [{ sku: "mug", price: 20, qty: 1 }];
  expect(checkoutTotal(cart, 10, 0.1)).toBe(19.8);
});
