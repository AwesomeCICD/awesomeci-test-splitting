const { isValidEmail, displayName } = require("../users");

const delayMs = Number(process.env.DEMO_TEST_DELAY_MS || 2500);
const delay = (ms = delayMs) => new Promise((resolve) => setTimeout(resolve, ms));

test("validates email and formats a display name", async () => {
  await delay();
  expect(isValidEmail("ada@example.com")).toBe(true);
  expect(isValidEmail("not-an-email")).toBe(false);
  expect(displayName({ first: "Ada", last: "Lovelace" })).toBe("Ada Lovelace");
});
