#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
GODOT_BIN="${GODOT_BIN:-godot}"
mkdir -p artifacts
"$GODOT_BIN" --headless --editor --import --quit 2>&1 | tee artifacts/import.log
if grep -Eq 'SCRIPT ERROR|Parse Error|ERROR:' artifacts/import.log; then
  exit 1
fi
"$GODOT_BIN" --headless --fixed-fps 60 --script tests/run_tests.gd 2>&1 | tee artifacts/tests.log
if grep -Eq 'SCRIPT ERROR|Parse Error|ERROR:' artifacts/tests.log; then
  exit 1
fi
grep -Eq 'ORION TEST RESULT: [0-9]+ checks, 0 failures' artifacts/tests.log
