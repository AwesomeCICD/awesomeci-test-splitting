function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function displayName(user) {
  return `${user.first} ${user.last}`.trim();
}

module.exports = { isValidEmail, displayName };
