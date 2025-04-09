# AwesomeCI Test Splitting Demo

This repository demonstrates test splitting in a continuous integration (CI) pipeline using a large-scale, multi-language codebase. It contains two main components:

- A PHP backend with a large number of test files.
- A React frontend application with unit tests.
- A simple way to build a Docker image and push it to AWS ECR

The purpose is to simulate real-world projects with high test volume and showcase test parallelization and dynamic splitting strategies in CI systems like CircleCI.

---

## Project Structure

```
awesomeci-test-splitting-main/
├── php/                  # PHP backend code
│   ├── src/              # Source files
│   └── tests/            # PHPUnit test files
├── react/                # React frontend app
│   ├── public/
│   ├── src/              # Source code and unit tests
│   └── config/           # Webpack and environment config
└── scripts/              # Supporting scripts (e.g., push to ECR)
```

---

## Sample Config

### CI Setup

Use this repo to test:
- Test splitting based on timing data
- Running different workflows in parallel across React and PHP
- Testing the value of CircleCI's DLC feature ([link](https://app.circleci.com/pipelines/github/AwesomeCICD/awesomeci-test-splitting/43/workflows/f46a8cd1-c255-40f4-8fdc-dce4aa8d56a0)]

---

## Scripts

- `scripts/push-ecr-image.sh` — Utility for pushing a Docker image to AWS ECR (used in some CI demos).

---

## License

MIT
