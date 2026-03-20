# Vibecoding System — Claude Code Setup

A portable, stack-agnostic system for collaborating with Claude Code. Clone this repo, copy 3 files, and every project you start will have enforced quality gates, parallel agents, and a safe git workflow — automatically.

---

## What's In Here

```
vibecoding-system/
├── UNIVERSAL_SEED.md          ← copy to any project as CLAUDE.md
├── global-setup/
│   ├── settings.json          ← copy to ~/.claude/  (one-time per machine)
│   └── statusline-command.sh  ← copy to ~/.claude/  (one-time per machine)
└── hooks/
    ├── analyze-on-edit.sh     ← fires on every file edit
    ├── block-dangerous.sh     ← blocks force push + prod ops
    ├── quality-gate.sh        ← runs before Claude says "done"
    ├── settings-template.json ← project-level .claude/settings.json
    └── stack-examples/        ← Claude generates these — examples here
        ├── flutter/
        ├── node/
        └── python/
```

---

## Setup (One Time Per Machine)

1. Clone this repo or download the files
2. Copy `global-setup/settings.json` → `C:\Users\[you]\.claude\settings.json`
3. Copy `global-setup/statusline-command.sh` → `C:\Users\[you]\.claude\statusline-command.sh`
4. Copy `UNIVERSAL_SEED.md` → `C:\Users\[you]\.claude\UNIVERSAL_SEED.md`
5. Reload VS Code: `Ctrl+Shift+P` → `Developer: Reload Window`

That's it. The status bar activates and Claude will auto-approve actions.

---

## Starting a New Project

1. Copy `UNIVERSAL_SEED.md` into your project root and rename it `CLAUDE.md`
2. Copy the `hooks/` folder contents into your project's `.claude/hooks/`
3. Copy `hooks/settings-template.json` to your project's `.claude/settings.json`
4. Open Claude Code and describe what you're building
5. Claude detects your tech stack, proposes the right lint/test hooks, and asks you to confirm
6. Done — quality gates, git rules, and agents are all live

---

## How Stack Detection Works

The hooks (`analyze-on-edit.sh`, `quality-gate.sh`) are stack-agnostic. They delegate to 3 small stub files that Claude generates for your specific project:

| File | What it does |
|------|-------------|
| `.claude/hooks/on-edit-lint.sh` | Lints the file just edited (receives filepath as $1) |
| `.claude/hooks/run-lint.sh` | Full project lint (called by quality gate) |
| `.claude/hooks/run-tests.sh` | Full test run (called by quality gate) |

Claude generates these automatically after detecting your stack. See `hooks/stack-examples/` for reference implementations.

---

## What You Get

- **No approval popups** — Claude works automatically
- **Live VS Code status bar** — see exactly what Claude is doing in real-time
- **Lint on every edit** — bad code is caught immediately, not at session end
- **Quality gate before done** — Claude can't declare victory with failing tests or lint errors
- **Force push blocked** — destructive git ops require explicit approval
- **Git history** — conventional commits make every change self-documenting
- **Parallel agents** — research, coding, and testing run simultaneously

---

## First Message (Every New Session)

```
New session. Confirm you've read CLAUDE.md and the rules in .claude/rules/.
Tell me what branch I'm on and what the quality gates are. Then: [your goal].
```
