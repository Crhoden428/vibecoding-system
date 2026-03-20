#!/bin/bash
# Python: lint the file just edited.
FILE="$1"
[[ "$FILE" != *.py ]] && exit 0
OUTPUT=$(ruff check "$FILE" 2>&1)
EXIT=$?
echo "$OUTPUT" >&2
if [ $EXIT -ne 0 ]; then
  echo "Ruff found issues in $FILE. Fix before continuing."
  exit 2
fi
echo "✓ $FILE" >&2
exit 0
