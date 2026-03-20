#!/bin/bash
# Flutter: run all tests.
if ! find test -name "*_test.dart" -quit 2>/dev/null | grep -q .; then
  echo "No test files found — skipping." >&2
  exit 0
fi
flutter test --no-pub 2>&1
exit $?
