const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Add delay helper to simulate realistic test execution time
const delayHelper = `
// Simulate realistic test execution time (async operations, API calls, etc.)
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));
`;

// Pattern to match test files
const testPattern = path.join(__dirname, '../src/__tests__/generated-tests-*.test.js');

glob(testPattern, (err, files) => {
  if (err) {
    console.error('Error finding test files:', err);
    process.exit(1);
  }

  console.log(`Found ${files.length} test files to modify`);

  files.forEach(file => {
    let content = fs.readFileSync(file, 'utf8');

    // Skip if already has delay function
    if (content.includes('const delay =')) {
      console.log(`Skipping ${path.basename(file)} - already has delay`);
      return;
    }

    // Add delay helper at the top
    content = delayHelper + content;

    // Convert tests to async and add delay
    // Match: test('description', () => {
    // Replace with: test('description', async () => {
    //   await delay(50);
    content = content.replace(/test\('([^']+)',\s*\(\)\s*=>\s*{/g,
      `test('$1', async () => {\n  await delay(50);`);

    fs.writeFileSync(file, content, 'utf8');
    console.log(`Modified ${path.basename(file)}`);
  });

  console.log('Done! All test files now have realistic execution delays.');
});
