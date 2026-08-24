const { subtotal } = require("./cart");
const { applyDiscount, tax } = require("./pricing");

function checkoutTotal(cart, discountPercent, taxRate) {
  const afterDiscount = applyDiscount(subtotal(cart), discountPercent);
  return afterDiscount + tax(afterDiscount, taxRate);
}

module.exports = { checkoutTotal };
