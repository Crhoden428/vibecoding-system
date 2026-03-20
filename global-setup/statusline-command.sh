#!/usr/bin/env bash
# Claude Code statusline — shows model, directory, git branch, context usage
# Copy to ~/.claude/statusline-command.sh

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')

# Shorten to last 2 path segments for readability
short_cwd=$(echo "$cwd" | awk -F'/' '{print $(NF-1)"/"$NF}')
if [ -z "$short_cwd" ] || [ "$short_cwd" = "/" ]; then
  short_cwd="$cwd"
fi

branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

parts="${model}"

if [ -n "$session_name" ]; then
  parts="${parts}  |  ${session_name}"
fi

parts="${parts}  |  ${short_cwd}"

if [ -n "$branch" ]; then
  parts="${parts}  (${branch})"
fi

if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  parts="${parts}  |  ctx: ${used_int}%"
fi

printf "%s" "$parts"
