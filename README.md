<div align="center">

# 🧠 Loubrain

**The skill that thinks before it builds.**

Loubrain runs *first* on every build **or** big-change request — new projects, refactors, rewrites, migrations, redesigns. It pins down what you actually want, elects the best tool **and** agent your library has for each job, flags what's missing, and only starts once you approve the plan. No keyword needed: it fires on intent. Full-featured on [Claude Code](https://claude.com/claude-code); portable adapters ship for Codex CLI, Gemini CLI, and Cursor.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-skill-6E56CF.svg)](https://claude.com/claude-code)
[![Also supports](https://img.shields.io/badge/also-Codex%20%7C%20Gemini%20CLI%20%7C%20Cursor-informational.svg)](#compatibility)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)](#installation)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## Why

A big skill library is a curse as much as a blessing. Ask Claude to "build a landing page" and it grabs whatever skill triggers first — not necessarily the *best* of the 4–5 design skills you have installed. There's no step that stops, looks at the whole toolbox, and picks deliberately.

Loubrain is that step. It's the brain that runs before the hands.

## What it does

```
You: "refactor this codebase to use server components"

Loubrain:
  1. Pins the goal      → asks focused questions (each with a recommended default)
  2. Elects the toolset → best skill + agent per capability, from YOUR library
  3. Shows the roster   → a table of exactly what it will use, and why
  4. Flags gaps         → suggests skills worth installing, with sources
  5. Waits for go       → works only after your green light
```

## When it fires

On **intent alone** — you never type `/loubrain` or any keyword:

| Fires | Stays out of the way |
|---|---|
| build / create / scaffold a project, app, site, tool, bot | fix this typo |
| improve / refactor / rewrite / redesign / restructure | rename this variable |
| migrate / port / modernize / upgrade | change one config value |
| add a feature, subsystem, or module | answer a question about the code |
| anything framed as major, large, or from scratch | |

The rule of thumb it follows: when a change is somewhere between trivial and substantial, run — a short brief costs far less than doing a big change with the wrong tools.

## Features

- **🎯 Goal-first.** Extracts the real end goal — what you'll *do* with the result — before a line of code. Asks as many focused questions as it takes, each with a recommended default so you can just hit accept.
- **🗳️ Skill elections.** When 4–5 skills compete for the same job, Loubrain spins up a **Claude Sonnet** subagent that reads each candidate, researches the approaches on the web + Reddit/dev blogs, and scores them on goal-match, specificity, coverage, and external verdict. One winner per capability.
- **🤖 Agents too.** Reviewers, resolvers, and other subagents are elected the same way — not left to chance.
- **💸 Cost-aware.** The election (the expensive, research-heavy part) runs on Sonnet, not the main model, and only fires when a capability genuinely has 2+ rivals. Single-option jobs skip it entirely.
- **🔌 Gap suggestions.** Missing a capability? Loubrain researches the best installable skill/plugin and suggests it — with a source — before you build. Never installs without your OK.
- **✋ Green-light gate.** Shows the full roster and stops. You approve, swap, or drop picks before anything is built.
- **⚡ Always first, no keyword.** A global `CLAUDE.md` rule plus a `UserPromptSubmit` hook make it the mandatory first step on any build *or* change request. It fires on intent — you never name it, and waiting to be asked counts as a failure to run.
- **🔗 Hands-free handoff.** Once you approve the roster, the assistant invokes each elected skill itself. No `/skill-name` to type, no second round of "should I use X now?" — the approved roster is the authorization.

## How it works

Loubrain runs in five phases. Full detail in [docs/how-it-works.md](docs/how-it-works.md).

| Phase | What happens | Model |
|-------|--------------|-------|
| **1. Goal** | Restate the deliverable, name the end goal, ask focused questions with recommended defaults | main |
| **2. Election** | Find candidate skills + agents per capability; when 2+ compete, a web-researched Sonnet election picks the winner | Sonnet subagent |
| **3. Roster** | Show the capability → skill → agent table with reasons, then wait for approval | main |
| **4. Gaps** | Research + suggest installable skills for any capability with no candidate | main |
| **5. Build** | After green light, invoke each elected skill + agent directly — no keyword from you | main |

## Compatibility

Loubrain's logic is written once, tool-agnostically, in [docs/PROTOCOL.md](docs/PROTOCOL.md). Each assistant gets an adaptation into that tool's own convention for loading standing instructions:

| Assistant | File | Scope | Notes |
|---|---|---|---|
| **Claude Code** | `skills/loubrain/SKILL.md` | global (`~/.claude`) | Full version — real skill/agent election via a pinned Sonnet subagent, `AskUserQuestion` prompts, a `CLAUDE.md` override rule, and a `UserPromptSubmit` hook. Installed by `install.ps1` / `install.sh`. |
| **Codex CLI** (and other `AGENTS.md`-convention tools) | `AGENTS.md` | project root | Auto-read by Codex when present at the repo root. Copy it into any repo where you want Loubrain active. |
| **Gemini CLI** | `GEMINI.md` | project root, or `~/.gemini/GEMINI.md` for global | Same convention as `CLAUDE.md`, Gemini's own filename. |
| **Cursor** | `.cursor/rules/loubrain.mdc` | project | Cursor project rule, `alwaysApply: true`. Copy the `.cursor/rules/` folder into your project. |

The adapted files describe the same five phases but never name a Claude-specific tool (`Skill`, `Agent`, `AskUserQuestion`) — they lean on whatever equivalent mechanism the host tool provides (installed-capability lists, web search, sub-model delegation, a way to ask the user questions). If you use an assistant not listed here, [docs/PROTOCOL.md](docs/PROTOCOL.md) has everything needed to write a new adapter — PRs welcome.

## Installation

### Claude Code (full version)

```powershell
# Windows (PowerShell)
git clone https://github.com/Ra1zmm/loubrain.git
cd loubrain
powershell -ExecutionPolicy Bypass -File install.ps1
```

```bash
# macOS / Linux
git clone https://github.com/Ra1zmm/loubrain.git
cd loubrain
bash install.sh
```

The installer copies the skill and hook into `~/.claude`, adds the "always-first" rule to your `~/.claude/CLAUDE.md`, and wires the `UserPromptSubmit` hook into `~/.claude/settings.json`. It's idempotent — safe to re-run. See [Manual install](#manual-install) if you'd rather wire it yourself.

Restart Claude Code (or open `/hooks` once) after installing so the hook loads.

### Codex CLI, Gemini CLI, Cursor, or other assistants

These tools read standing instructions straight from your project (no install script needed):

```bash
git clone https://github.com/Ra1zmm/loubrain.git
# Codex CLI / AGENTS.md-convention tools:
cp loubrain/AGENTS.md your-project/AGENTS.md
# Gemini CLI:
cp loubrain/GEMINI.md your-project/GEMINI.md
# Cursor:
cp -r loubrain/.cursor/rules your-project/.cursor/rules
```

Check your tool's docs for where it expects the file (project root vs. a global home directory) if you want it active everywhere instead of one repo.

## Usage

There's nothing to invoke. Just ask for the work:

```
build me a react dashboard for my sales data
refactor this codebase to use server components
migrate the database from mongo to postgres
```

Loubrain takes over on its own: asks what it needs, shows you the roster, waits for your go, then runs the elected skills itself. `/loubrain` still works if you want to force it on something it judged trivial.

## Repository structure

```
loubrain/
├── skills/loubrain/SKILL.md      # Claude Code: the full skill (the 5-phase logic)
├── skills/loubrain/evals/        # test prompts + assertions
├── hooks/loubrain-nudge.ps1      # Claude Code: UserPromptSubmit "always-first" nudge
├── install.ps1 / install.sh      # Claude Code installers
├── AGENTS.md                     # Codex CLI / AGENTS.md-convention tools
├── GEMINI.md                     # Gemini CLI
├── .cursor/rules/loubrain.mdc    # Cursor
├── docs/PROTOCOL.md              # tool-agnostic source of truth for all adapters
├── docs/how-it-works.md          # deep dive (Claude Code specifics)
└── .github/                      # CI + issue templates
```

## Manual install

If you prefer not to run the script:

1. Copy `skills/loubrain/` → `~/.claude/skills/loubrain/`
2. Copy `hooks/loubrain-nudge.ps1` → `~/.claude/loubrain-hooks/loubrain-nudge.ps1`
3. Add the block from [docs/how-it-works.md#config](docs/how-it-works.md#config) to `~/.claude/CLAUDE.md` and `~/.claude/settings.json`.

## Publishing your own copy

The repo is ready to push as-is (branch `main`). With the [GitHub CLI](https://cli.github.com/), one command creates the remote and pushes:

```bash
gh repo create Ra1zmm/loubrain --public --source . --remote origin --push
```

No `gh`? Create an empty `loubrain` repo at [github.com/new](https://github.com/new), then:

```bash
git remote add origin https://github.com/Ra1zmm/loubrain.git
git push -u origin main
```

The `validate` workflow runs automatically on the first push.

## Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Loubrain contributors
