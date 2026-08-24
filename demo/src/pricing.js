function applyDiscount(amount, percent) {
  return amount * (1 - percent / 100);
}

function tax(amount, rate) {
  return Math.round(amount * rate * 100) / 100;
}

module.exports = { applyDiscount, tax };
