function shippingCost(weightLb, zone) {
  const base = zone === "remote" ? 18 : 8;
  return base + weightLb * 0.5;
}

module.exports = { shippingCost };
