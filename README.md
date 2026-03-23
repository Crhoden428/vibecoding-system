# Vibecoding System — Claude Code Setup

A portable, stack-agnostic system for collaborating with Claude Code. Clone this repo, copy a few files, and every project you touch will have enforced quality gates, parallel agents, and a safe git workflow — automatically, with no approval popups.

---

## What's In Here

```
vibecoding-system/
├── CLAUDE.md                  ← the template — copy into any project as CLAUDE.md
├── global-setup/
│   ├── settings.json          ← copy to ~/.claude/ once per machine
│   └── statusline-command.sh  ← copy to ~/.claude/ once per machine
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

## One-Time Machine Setup

Do this once. It applies to every project.

```bash
git clone https://github.com/Crhoden428/vibecoding-system.git
cd vibecoding-system

cp global-setup/settings.json ~/.claude/settings.json
cp global-setup/statusline-command.sh ~/.claude/statusline-command.sh
mkdir -p ~/.claude/hooks
cp hooks/block-dangerous.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/block-dangerous.sh ~/.claude/statusline-command.sh
```

Then in VS Code: `Ctrl+Shift+P` → `Developer: Reload Window`

The status bar activates. Claude auto-approves all actions. Dangerous git ops are blocked globally.

---

## New Project Setup

```bash
# From your project root:
cp /path/to/vibecoding-system/CLAUDE.md CLAUDE.md
mkdir -p .claude/hooks .claude/rules
cp /path/to/vibecoding-system/hooks/analyze-on-edit.sh .claude/hooks/
cp /path/to/vibecoding-system/hooks/block-dangerous.sh .claude/hooks/
cp /path/to/vibecoding-system/hooks/quality-gate.sh .claude/hooks/
cp /path/to/vibecoding-system/hooks/settings-template.json .claude/settings.json
chmod +x .claude/hooks/*.sh
```

Open Claude Code and say:
> "Read CLAUDE.md and help me fill it in for this project, then generate the stack quality hooks."

Claude detects your stack, fills in the project-specific sections through conversation, generates the lint/test stubs, and asks you to confirm. Done.

---

## Existing Project (Already Has a CLAUDE.md)

Don't overwrite it. Instead, tell Claude:

> "Merge the working rules from [vibecoding-system]/CLAUDE.md into my existing CLAUDE.md. Keep all project-specific content. Add the multiagent, git workflow, and quality gate sections if they're missing or weaker."

Claude reads both files and merges them. Your project context stays intact; the working rules get added or upgraded.

Then copy the hooks as above.

---

## How Stack Detection Works

The three universal hooks delegate to small stub files Claude generates for your stack:

| Stub | What it does |
|------|-------------|
| `.claude/hooks/on-edit-lint.sh` | Lints the file just edited (receives filepath as `$1`) |
| `.claude/hooks/run-lint.sh` | Full project lint (called at quality gate) |
| `.claude/hooks/run-tests.sh` | Full test suite (called at quality gate) |

Claude generates these after detecting your stack. See `hooks/stack-examples/` for reference.

---

## What You Get

- **No approval popups** — Claude edits, runs bash, and tests without asking
- **Live VS Code status bar** — see what Claude is doing in real-time
- **Lint on every edit** — bad code caught immediately, not at session end
- **Quality gate before done** — Claude can't declare victory with failing tests or lint errors
- **Force push blocked** — destructive git ops stopped before they run
- **Parallel agents** — research, coding, and testing run simultaneously by default
- **Conventional commits** — every change is self-documenting

---

## First Message (Every New Session)

```
New session. Confirm you've read CLAUDE.md and the rules in .claude/rules/.
Tell me what branch I'm on and what the quality gates are. Then: [your goal].
```
