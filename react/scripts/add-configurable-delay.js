const fs = require('fs');
const path = require('path');
const glob = require('glob');

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

    // Replace the existing delay function with one that reads from environment variable
    const oldDelay = `// Simulate realistic test execution time (async operations, API calls, etc.)
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));`;

    const newDelay = `// Simulate realistic test execution time (async operations, API calls, etc.)
// Use TEST_DELAY_MS environment variable or default to 50ms
const TEST_DELAY = process.env.TEST_DELAY_MS ? parseInt(process.env.TEST_DELAY_MS) : 50;
const delay = (ms = TEST_DELAY) => new Promise(resolve => setTimeout(resolve, ms));`;

    if (content.includes('const TEST_DELAY =')) {
      console.log(`Skipping ${path.basename(file)} - already has configurable delay`);
      return;
    }

    content = content.replace(oldDelay, newDelay);

    // Update delay calls to not pass parameter (will use TEST_DELAY default)
    content = content.replace(/await delay\(50\);/g, 'await delay();');

    fs.writeFileSync(file, content, 'utf8');
    console.log(`Modified ${path.basename(file)}`);
  });

  console.log('Done! All test files now have configurable delays via TEST_DELAY_MS env var.');
});
