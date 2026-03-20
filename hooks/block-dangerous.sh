#!/bin/bash
# Hook: block dangerous git and database operations.
# Fires on: PreToolUse (Bash)
# Universal — no stack-specific logic.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -oP '"command"\s*:\s*"\K[^"]+(?=")' | head -1)

# Block force pushes to any branch
if echo "$COMMAND" | grep -qE "git push.*(--force|-f\b)"; then
  echo "Blocked: force push is never allowed." >&2
  echo "BLOCKED: Force push is never allowed. Stop and explain why this is needed."
  exit 2
fi

# Block direct push to main
if echo "$COMMAND" | grep -qE "git push origin main$"; then
  echo "Blocked: direct push to main." >&2
  echo "BLOCKED: Direct push to main is not allowed. Use a feature branch and open a PR."
  exit 2
fi

exit 0
