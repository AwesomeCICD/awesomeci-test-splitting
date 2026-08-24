const { addItem, itemCount, subtotal } = require("../cart");

const delayMs = Number(process.env.DEMO_TEST_DELAY_MS || 2500);
const delay = (ms = delayMs) => new Promise((resolve) => setTimeout(resolve, ms));

test("adds items and totals the cart", async () => {
  await delay();
  const cart = addItem([], { sku: "mug", price: 12, qty: 2 });
  expect(itemCount(cart)).toBe(2);
  expect(subtotal(cart)).toBe(24);
});
