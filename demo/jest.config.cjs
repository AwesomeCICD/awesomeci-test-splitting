const path = require("path");

module.exports = {
  rootDir: path.join(__dirname, ".."),
  testEnvironment: "node",
  testMatch: ["<rootDir>/demo/src/**/*.test.js"],
  reporters: [
    "default",
    [require.resolve("jest-junit"), { addFileAttribute: "true" }],
  ],
};
