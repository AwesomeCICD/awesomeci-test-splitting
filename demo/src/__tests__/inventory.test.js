const { isInStock, reserve } = require("../inventory");

const delayMs = Number(process.env.DEMO_TEST_DELAY_MS || 2500);
const delay = (ms = delayMs) => new Promise((resolve) => setTimeout(resolve, ms));

test("reserves stock when available", async () => {
  await delay();
  const warehouse = { mug: 3 };
  expect(isInStock("mug", warehouse)).toBe(true);
  expect(reserve("mug", 2, warehouse)).toEqual({ mug: 1 });
});
