function isInStock(sku, warehouse) {
  return Boolean(warehouse[sku] && warehouse[sku] > 0);
}

function reserve(sku, qty, warehouse) {
  if (!warehouse[sku] || warehouse[sku] < qty) {
    throw new Error("out of stock");
  }
  return { ...warehouse, [sku]: warehouse[sku] - qty };
}

module.exports = { isInStock, reserve };
