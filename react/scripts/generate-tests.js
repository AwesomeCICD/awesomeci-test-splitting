const fs = require('fs');
const path = require('path');

const testsDir = path.join(__dirname, '../src/__tests__');
const numFiles = 140; // 140 files with 50 tests each = 7000 tests
const testsPerFile = 50;

// Clear existing generated test files
const existingFiles = fs.readdirSync(testsDir);
existingFiles.forEach(file => {
  if (file.startsWith('generated-')) {
    fs.unlinkSync(path.join(testsDir, file));
  }
});

console.log('Generating 7000 tests across 140 files...');

for (let fileNum = 1; fileNum <= numFiles; fileNum++) {
  const fileName = `generated-tests-${String(fileNum).padStart(3, '0')}.test.js`;
  const filePath = path.join(testsDir, fileName);

  let testContent = `// Auto-generated test file ${fileNum} of ${numFiles}\n\n`;

  // Generate different types of tests to make them more realistic
  for (let testNum = 1; testNum <= testsPerFile; testNum++) {
    const globalTestNum = (fileNum - 1) * testsPerFile + testNum;
    const testType = globalTestNum % 6;

    switch(testType) {
      case 0: // Math tests
        testContent += `test('Math test ${globalTestNum}: addition', () => {
  expect(${globalTestNum % 100} + ${globalTestNum % 50}).toBe(${(globalTestNum % 100) + (globalTestNum % 50)});
});\n\n`;
        break;
      case 1: // String tests
        testContent += `test('String test ${globalTestNum}: concatenation', () => {
  const str = 'test' + ${globalTestNum};
  expect(str).toBe('test${globalTestNum}');
});\n\n`;
        break;
      case 2: // Array tests
        testContent += `test('Array test ${globalTestNum}: length', () => {
  const arr = new Array(${globalTestNum % 20 + 1}).fill(${globalTestNum});
  expect(arr.length).toBe(${globalTestNum % 20 + 1});
});\n\n`;
        break;
      case 3: // Boolean tests
        testContent += `test('Boolean test ${globalTestNum}: truthiness', () => {
  expect(${globalTestNum} > 0).toBe(true);
  expect(!!${globalTestNum}).toBe(true);
});\n\n`;
        break;
      case 4: // Object tests
        testContent += `test('Object test ${globalTestNum}: properties', () => {
  const obj = { id: ${globalTestNum}, value: ${globalTestNum * 2} };
  expect(obj.id).toBe(${globalTestNum});
  expect(obj.value).toBe(${globalTestNum * 2});
});\n\n`;
        break;
      case 5: // Function tests
        testContent += `test('Function test ${globalTestNum}: execution', () => {
  const fn = (x) => x * ${globalTestNum % 10 + 1};
  expect(fn(2)).toBe(${(globalTestNum % 10 + 1) * 2});
});\n\n`;
        break;
    }
  }

  fs.writeFileSync(filePath, testContent);

  if (fileNum % 20 === 0) {
    console.log(`Generated ${fileNum * testsPerFile} tests...`);
  }
}

console.log(`✓ Successfully generated ${numFiles * testsPerFile} tests in ${numFiles} files!`);
