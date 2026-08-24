function addItem(cart, item) {
  return [...cart, item];
}

function itemCount(cart) {
  return cart.reduce((sum, item) => sum + item.qty, 0);
}

function subtotal(cart) {
  return cart.reduce((sum, item) => sum + item.price * item.qty, 0);
}

module.exports = { addItem, itemCount, subtotal };
