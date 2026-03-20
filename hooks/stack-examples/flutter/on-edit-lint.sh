#!/bin/bash
# Flutter/Dart: lint the file just edited.
# Called by analyze-on-edit.sh with the file path as $1.
FILE="$1"
[[ "$FILE" != *.dart ]] && exit 0
OUTPUT=$(dart analyze "$FILE" --fatal-warnings 2>&1)
EXIT=$?
echo "$OUTPUT" >&2
if [ $EXIT -ne 0 ]; then
  echo "Dart analyze found issues in $FILE. Fix before continuing."
  exit 2
fi
echo "✓ $FILE" >&2
exit 0
