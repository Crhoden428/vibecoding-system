#!/bin/bash
# Node/JS/TS: lint the file just edited.
FILE="$1"
[[ "$FILE" != *.js && "$FILE" != *.ts && "$FILE" != *.jsx && "$FILE" != *.tsx ]] && exit 0
OUTPUT=$(npx eslint "$FILE" 2>&1)
EXIT=$?
echo "$OUTPUT" >&2
if [ $EXIT -ne 0 ]; then
  echo "ESLint found issues in $FILE. Fix before continuing."
  exit 2
fi
echo "✓ $FILE" >&2
exit 0
