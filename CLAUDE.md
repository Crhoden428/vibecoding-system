# [PROJECT NAME] — Claude Code Instructions
# Loaded automatically at the start of every session.
# Claude fills in project specifics through conversation — no manual editing needed.

## What This Project Is
<!-- Claude: if this section is empty, ask the user to describe the project before doing
anything else. Capture: what it does, who it's for, the tech stack, target platforms,
and any key third-party services. Fill this in from their answer. -->

---

## Stack & Hooks Setup
<!-- Claude: at the start of any NEW project (no .claude/hooks/on-edit-lint.sh exists):
1. Detect the stack: check for pubspec.yaml (Flutter), package.json (Node/JS),
   requirements.txt or pyproject.toml (Python), Cargo.toml (Rust), go.mod (Go), etc.
2. Tell the user: "I detected [X stack]. I'll configure the quality hooks for that.
   Confirm?" Wait for approval before generating anything.
3. On approval, generate these 3 files in .claude/hooks/:
   - on-edit-lint.sh  (lints the file just edited, receives filepath as $1)
   - run-lint.sh      (full project lint, called by quality gate)
   - run-tests.sh     (full test suite, called by quality gate)
   Use the best available tool for the detected stack. See stack-examples/ in the
   vibecoding-system repo for reference implementations.
4. Also fill in the Build & Run Commands section below. -->

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
- Force push (`--force` / `-f`) to any branch — ever.
- Commit directly to `main` or `develop`.
- Leave uncommitted changes at end of session — commit or stash.
- Use `git add .` — stage specific files to avoid committing secrets or binaries.

---

## Quality Gates (Run Before Declaring Done)
<!-- Claude: fill these in after stack detection -->
```bash
# Lint:  [filled in by Claude after stack detection]
# Test:  [filled in by Claude after stack detection]
```

---

## Safety Rules
- Never deploy to production unless explicitly requested. Default to staging/testing.
- Never edit existing migration files — always create new ones.
- Stage specific files only — never `git add .` or `git add -A`.
- If unsure whether an action is destructive, ask before proceeding.

---

## Build & Run Commands
<!-- Claude: fill in after stack detection -->
```bash
# Install:  [filled in by Claude]
# Lint:     [filled in by Claude]
# Test:     [filled in by Claude]
# Build:    [filled in by Claude]
# Run:      [filled in by Claude]
```

---

## Architecture Rules
<!-- Claude: ask the user for any non-obvious architectural rules specific to this project.
Examples: state management approach, where new data fields go, async patterns, etc.
Fill in from their answers. Leave blank if none provided. -->

---

## Technical Constants
<!-- Claude: fill in as you discover key values — API endpoints, magic numbers,
active services, DB identifiers, etc. These help future sessions avoid bugs. -->

---

## Key File Paths
<!-- Claude: fill in as the codebase becomes clear. -->
| Component | Path |
|-----------|------|

---

## GitHub Repo
<!-- Claude: fill in from git remote -v -->
Remote: ``
Branch: ``
