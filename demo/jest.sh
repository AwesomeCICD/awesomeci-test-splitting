#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "${ROOT}/.." && pwd)"
cd "${REPO}"

exec npx --prefix "${ROOT}" jest --config "${ROOT}/jest.config.cjs" "$@"
