# ============================================================
# HOW TO USE THIS FILE
# ============================================================
# 1. Drop this file into your project folder
#    (or upload it to a Claude.ai Project)
# 2. Say: "Read vibecoding-seed.md and carry out the bootstrap instructions."
#    (or just "follow this" / "do this" — VS Code Claude Code will auto-detect it)
# 3. That's it. Claude handles everything else.
#    Works for new and existing projects.
# ============================================================

# [PROJECT NAME] — Claude Code Instructions

<!-- ============================================================
BOOTSTRAP INSTRUCTIONS (Claude executes this on first run)
Remove this entire block after bootstrap is complete.
============================================================

You are setting up the Vibecoding System for this project.
Work through the following steps in order. Do not skip any.

STEP 1 — DETECT ENVIRONMENT
Check whether this is VS Code Claude Code or Claude.ai Projects:
- If .claude/ directory exists or can be created → VS Code Claude Code
- If you cannot write files to disk → Claude.ai Projects
Proceed with the appropriate path below.

STEP 2 — DETECT EXISTING PROJECT
Check whether a CLAUDE.md file already exists in this project folder.

If CLAUDE.md EXISTS:
- Read it. Do not overwrite it.
- Merge the Working Rules, Git Workflow, Quality Gates, and Safety Rules sections
  from this file into the existing CLAUDE.md — only adding what is missing or weaker.
- Keep all existing project-specific content exactly as-is.
- Skip the "what is this project" question — the context is already there.
- Save the updated CLAUDE.md, then delete vibecoding-seed.md.
- Proceed directly to hook setup (Step A2) and stack detection (Step A3).

If CLAUDE.md DOES NOT EXIST:
- This file will become CLAUDE.md at the end of bootstrap (Step A5).
- Proceed through all steps in order as written.

─── PATH A: VS CODE CLAUDE CODE ──────────────────────────────

STEP A1 — GLOBAL SETUP (one-time per machine)
Check if ~/.claude/settings.json exists and contains "effortLevel".
If it does NOT, create it now using the Write tool:

File: ~/.claude/settings.json
{
  "effortLevel": "high",
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/block-dangerous.sh" }]
      },
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/auto-bootstrap.sh" }]
      },
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "echo '{\"hookSpecificOutput\": {\"hookEventName\": \"PreToolUse\", \"permissionDecision\": \"allow\"}}'" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "bash .claude/hooks/analyze-on-edit.sh" }]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "bash .claude/hooks/quality-gate.sh" }]
      }
    ]
  }
}

If ~/.claude/settings.json ALREADY EXISTS, check whether it contains "auto-bootstrap.sh"
in the PreToolUse hooks. If not, add this entry to the PreToolUse array:
  { "matcher": "", "hooks": [{ "type": "command", "command": "bash ~/.claude/hooks/auto-bootstrap.sh" }] }

Always create these files regardless of whether settings.json existed:

File: ~/.claude/statusline-command.sh
#!/bin/bash
PROJECT=$(basename "$PWD")
BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
  echo "◆ $PROJECT  ⎇ $BRANCH"
else
  echo "◆ $PROJECT"
fi

File: ~/.claude/hooks/block-dangerous.sh
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -oP '"command"\s*:\s*"\K[^"]+(?=")' | head -1)
if echo "$COMMAND" | grep -qE "git push.*(--force|-f\b)"; then
  echo "Blocked: force push is never allowed." >&2
  echo "BLOCKED: Force push is never allowed. Stop and explain why this is needed."
  exit 2
fi
if echo "$COMMAND" | grep -qE "git push origin main$"; then
  echo "Blocked: direct push to main." >&2
  echo "BLOCKED: Direct push to main is not allowed. Use a feature branch and open a PR."
  exit 2
fi
exit 0

File: ~/.claude/hooks/auto-bootstrap.sh
#!/bin/bash
# Fires before every tool use. If vibecoding-seed.md is present and bootstrap
# hasn't run yet, instructs Claude to run it before doing anything else.
if [ -f "vibecoding-seed.md" ] && [ ! -f ".claude/.bootstrapped" ]; then
  echo "STOP. Before doing anything else: vibecoding-seed.md is present in this project. Read it now and carry out the bootstrap instructions completely. Do not proceed with any other task until bootstrap is finished."
fi

After writing those files, run: chmod +x ~/.claude/hooks/*.sh ~/.claude/statusline-command.sh

Then tell the user:
"Global setup complete. Would you mind reloading your VS Code window?
Ctrl+Shift+P → Developer: Reload Window
Then come back and I'll finish the project setup."
Wait for confirmation before continuing.

STEP A2 — PROJECT HOOK SETUP
Create the following files in the project:

File: .claude/settings.json
{
  "permissions": {
    "allow": ["Bash(git:*)", "Bash(ls:*)", "Bash(bash:*)", "WebSearch(*)", "WebFetch(*)", "Bash(chmod:*)"]
  },
  "hooks": {
    "PostToolUse": [
      { "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "bash .claude/hooks/analyze-on-edit.sh", "timeout": 60 }] }
    ],
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "bash .claude/hooks/block-dangerous.sh", "timeout": 10 }] }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "bash .claude/hooks/quality-gate.sh", "timeout": 180 }] }
    ]
  }
}

File: .claude/hooks/analyze-on-edit.sh
#!/bin/bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | grep -oP '"path"\s*:\s*"\K[^"]+(?=")' | head -1)
LINT_HOOK=".claude/hooks/on-edit-lint.sh"
if [ ! -f "$LINT_HOOK" ]; then
  echo "⚠️  Stack hooks not set up yet. Tell Claude: 'generate the stack quality hooks'" >&2
  exit 0
fi
bash "$LINT_HOOK" "$FILE"
exit $?

File: .claude/hooks/block-dangerous.sh
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -oP '"command"\s*:\s*"\K[^"]+(?=")' | head -1)
if echo "$COMMAND" | grep -qE "git push.*(--force|-f\b)"; then
  echo "BLOCKED: Force push is never allowed." && exit 2
fi
if echo "$COMMAND" | grep -qE "git push origin main$"; then
  echo "BLOCKED: Direct push to main is not allowed. Use a feature branch and open a PR." && exit 2
fi
exit 0

File: .claude/hooks/quality-gate.sh
#!/bin/bash
LINT_HOOK=".claude/hooks/run-lint.sh"
TEST_HOOK=".claude/hooks/run-tests.sh"
if [ ! -f "$LINT_HOOK" ] || [ ! -f "$TEST_HOOK" ]; then
  echo "⚠️  Stack hooks not configured — quality gate skipped." >&2
  exit 0
fi
echo "=== Quality Gate ===" >&2
LINT_OUTPUT=$(bash "$LINT_HOOK" 2>&1); LINT_EXIT=$?
echo "$LINT_OUTPUT" >&2
if [ $LINT_EXIT -ne 0 ]; then
  echo "QUALITY GATE FAILED: Lint errors found. Fix all errors before declaring done."
  exit 2
fi
TEST_OUTPUT=$(bash "$TEST_HOOK" 2>&1); TEST_EXIT=$?
echo "$TEST_OUTPUT" >&2
if [ $TEST_EXIT -ne 0 ]; then
  echo "QUALITY GATE FAILED: Tests failed. Fix all failures before declaring done."
  exit 2
fi
echo "✅ Quality gate passed." >&2
exit 0

Then run: chmod +x .claude/hooks/*.sh

STEP A3 — STACK DETECTION & QUALITY STUBS
Detect the stack by checking for these files:
- pubspec.yaml → Flutter/Dart
- package.json → Node/JS/TS
- requirements.txt or pyproject.toml → Python
- Cargo.toml → Rust
- go.mod → Go

Would you like me to generate the lint/test hooks for [X stack]?
On confirmation, generate:
- .claude/hooks/on-edit-lint.sh  (lints file at $1 on every edit)
- .claude/hooks/run-lint.sh      (full project lint)
- .claude/hooks/run-tests.sh     (full test suite)
Use the best available linter/test runner for the stack.
Run chmod +x on all three after creating them.

STEP A4 — FILL IN THIS FILE
Ask the user: "Could you tell me what this project is? What it does, who it's for, and the main
tech stack?" Fill in the sections below from their answer. Also run:
  git remote -v
to get the GitHub repo URL and branch.

STEP A5 — DONE
Remove the entire BOOTSTRAP INSTRUCTIONS block from this file (from the opening
<!-- to the closing --> comment). Rename this file from vibecoding-seed.md to CLAUDE.md.
Delete the original vibecoding-seed.md.
Write an empty file at `.claude/.bootstrapped` to prevent the auto-bootstrap hook
from triggering again.
Tell the user the system is fully active.

─── PATH B: CLAUDE.AI PROJECTS ──────────────────────────────

STEP B1 — CONFIRM SETUP
Tell the user:
"You're using Claude.ai Projects. The working rules below are now active for every
chat in this project. To complete setup, upload your key project files (main code,
README, docs) using the 'Add content' button. I'll have full context from now on."

STEP B2 — FILL IN THIS FILE
Ask the user: "Could you tell me what this project is? What it does, who it's for, and the
main tech stack?" Fill in the sections below from their answer.

STEP B3 — DONE
Delete the entire BOOTSTRAP INSTRUCTIONS block from this file.
Note: hooks and quality gates are not available in Claude.ai Projects — those require
VS Code Claude Code.

============================================================ -->

---

## What This Project Is
<!-- Filled in during bootstrap -->

---

## Working Rules (Always, Without Being Asked)

**Use multiagent mode** for any task touching more than one concern (research + code,
audit + fix, backend + frontend). Launch parallel agents — never do sequentially what
can run concurrently. Use `subagent_type: Explore` for codebase exploration,
`general-purpose` for web research. Use `isolation: worktree` when parallel agents
need to edit files simultaneously.

**Search before implementing** any non-trivial feature. APIs change, packages deprecate.
Use WebSearch proactively for current best practices. Don't wait to be asked.

**Plan before coding** for anything touching more than 2 files. Explore → plan → code.
Never jump straight to editing. Discuss architectural decisions before writing a line.

**No scope creep.** Fix what was asked. Do not improve adjacent code, add error handling
for impossible cases, add comments to untouched code, or add features not requested.

**Ask before big changes.** If a feature requires architectural decisions, align first.

---

## Git Workflow

### Branch Strategy
- `main` — production. Never commit directly.
- `develop` — staging/integration branch.
- `feature/[name]` — all feature work, branched from develop.
- `fix/[name]` — bug fixes, branched from develop (or main for hotfixes).

### Every Session
1. Check current branch: `git branch`
2. Pull latest: `git pull origin develop`
3. Create a feature branch if not already on one: `git checkout -b feature/[name]`
4. Commit in atomic logical chunks — not one giant commit at end of session.
5. Open a PR to develop when complete. Never merge directly to main or develop.

### Commit Messages — Conventional Commits
```
type(scope): short description under 72 chars

- Why the change was made (not just what)
- Any migration steps or deploy actions needed

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```
Types: `feat` `fix` `chore` `refactor` `docs` `test` `deploy`

### Never
- Force push to any branch — ever.
- Commit directly to `main` or `develop`.
- Leave uncommitted changes at end of session — commit or stash.
- Use `git add .` — stage specific files to avoid committing secrets.

---

## Quality Gates (Run Before Declaring Done)
<!-- Filled in during bootstrap -->

---

## Safety Rules
- Never deploy to production unless explicitly requested.
- Never edit existing migration files — always create new ones.
- Stage specific files only — never `git add .` or `git add -A`.
- If unsure whether an action is destructive, ask before proceeding.

---

## Deployed Infrastructure Rules

**Storage buckets — check before you upload or change paths.**
Never upload to a new folder path or change a download URL without first verifying:
- What bucket policies exist (public/private, which paths are accessible)
- Whether the destination path already has files at it
- Whether subfolders inherit permissions or need separate policies
If you can't verify this from existing docs or migrations, stop and ask.

**External service connections — check before you push.**
Before pushing to any repo connected to CI/CD (Vercel, Netlify, Cloudflare Pages, GitHub Actions):
- Know what services are watching that repo
- Know whether a push will trigger a deploy and to where
- If multiple services are connected (e.g. both Vercel and Cloudflare Pages), flag it

**URL/path changes on live infrastructure — verify accessibility first.**
If changing a URL, file path, or storage key that is referenced by a live deployed site:
- Test that the new destination is reachable before shipping the code change
- Do not assume new paths inherit the same permissions as old ones
- If you can't test it, say so explicitly instead of proceeding

**Confidence rule.**
If you don't know something with high confidence — especially around permissions,
external service behavior, or live infrastructure — say so before executing.
Do not proceed confidently and discover the gap after the fact.

---

## Build & Run Commands
<!-- Filled in during bootstrap -->

---

## Architecture Rules
<!-- Filled in during bootstrap -->

---

## Technical Constants
<!-- Filled in as discovered -->

---

## Key File Paths
| Component | Path |
|-----------|------|

---

## GitHub Repo
Remote: ``
Branch: ``
