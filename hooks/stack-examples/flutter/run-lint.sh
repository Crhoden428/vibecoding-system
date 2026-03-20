#!/bin/bash
# Flutter/Dart: full project lint.
OUTPUT=$(dart analyze --fatal-warnings 2>&1)
EXIT=$?
echo "$OUTPUT" >&2
exit $EXIT
