<div align="center">

# 🧠 Loubrain

**The skill that thinks before it builds.**

Loubrain is a master [Claude Code](https://claude.com/claude-code) skill that runs *first* on every "build me a…" request. It pins down what you actually want, elects the best skill **and** agent your library has for each job, flags what's missing, and only starts building once you approve the plan.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-skill-6E56CF.svg)](https://claude.com/claude-code)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)](#installation)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## Why

A big skill library is a curse as much as a blessing. Ask Claude to "build a landing page" and it grabs whatever skill triggers first — not necessarily the *best* of the 4–5 design skills you have installed. There's no step that stops, looks at the whole toolbox, and picks deliberately.

Loubrain is that step. It's the brain that runs before the hands.

## What it does

```
You: "build me a landing page for my coffee shop"

Loubrain:
  1. Pins the goal      → asks focused questions (each with a recommended default)
  2. Elects the toolset → best skill + agent per capability, from YOUR library
  3. Shows the roster   → a table of exactly what it will use, and why
  4. Flags gaps         → suggests skills worth installing, with sources
  5. Waits for go       → builds only after your green light
```

## Features

- **🎯 Goal-first.** Extracts the real end goal — what you'll *do* with the result — before a line of code. Asks as many focused questions as it takes, each with a recommended default so you can just hit accept.
- **🗳️ Skill elections.** When 4–5 skills compete for the same job, Loubrain spins up a **Claude Sonnet** subagent that reads each candidate, researches the approaches on the web + Reddit/dev blogs, and scores them on goal-match, specificity, coverage, and external verdict. One winner per capability.
- **🤖 Agents too.** Reviewers, resolvers, and other subagents are elected the same way — not left to chance.
- **💸 Cost-aware.** The election (the expensive, research-heavy part) runs on Sonnet, not the main model, and only fires when a capability genuinely has 2+ rivals. Single-option jobs skip it entirely.
- **🔌 Gap suggestions.** Missing a capability? Loubrain researches the best installable skill/plugin and suggests it — with a source — before you build. Never installs without your OK.
- **✋ Green-light gate.** Shows the full roster and stops. You approve, swap, or drop picks before anything is built.
- **⚡ Always first.** A global `CLAUDE.md` rule plus a `UserPromptSubmit` hook make it the mandatory first step on any build request — even when you never say its name.

## How it works

Loubrain runs in five phases. Full detail in [docs/how-it-works.md](docs/how-it-works.md).

| Phase | What happens | Model |
|-------|--------------|-------|
| **1. Goal** | Restate the deliverable, name the end goal, ask focused questions with recommended defaults | main |
| **2. Election** | Find candidate skills + agents per capability; when 2+ compete, a web-researched Sonnet election picks the winner | Sonnet subagent |
| **3. Roster** | Show the capability → skill → agent table with reasons, then wait for approval | main |
| **4. Gaps** | Research + suggest installable skills for any capability with no candidate | main |
| **5. Build** | After green light, build using each capability's elected skill + agent | main |

## Installation

Loubrain installs into your Claude Code config directory (`~/.claude`).

### Windows (PowerShell)

```powershell
git clone https://github.com/<your-username>/loubrain.git
cd loubrain
powershell -ExecutionPolicy Bypass -File install.ps1
```

### macOS / Linux

```bash
git clone https://github.com/<your-username>/loubrain.git
cd loubrain
bash install.sh
```

The installer copies the skill and hook into `~/.claude`, adds the "always-first" rule to your `~/.claude/CLAUDE.md`, and wires the `UserPromptSubmit` hook into `~/.claude/settings.json`. It's idempotent — safe to re-run. See [Manual install](#manual-install) if you'd rather wire it yourself.

Restart Claude Code (or open `/hooks` once) after installing so the hook loads.

## Usage

Just ask Claude to build something:

```
build me a react dashboard for my sales data
```

Loubrain takes over: asks what it needs, shows you the roster, and waits for your go. To invoke it explicitly, type `/loubrain`.

## Repository structure

```
loubrain/
├── skills/loubrain/SKILL.md      # the skill itself (the 5-phase logic)
├── skills/loubrain/evals/        # test prompts + assertions
├── hooks/loubrain-nudge.ps1      # UserPromptSubmit "always-first" nudge
├── install.ps1 / install.sh      # installers
├── docs/how-it-works.md          # deep dive
└── .github/                      # CI + issue templates
```

## Manual install

If you prefer not to run the script:

1. Copy `skills/loubrain/` → `~/.claude/skills/loubrain/`
2. Copy `hooks/loubrain-nudge.ps1` → `~/.claude/loubrain-hooks/loubrain-nudge.ps1`
3. Add the block from [docs/how-it-works.md#config](docs/how-it-works.md#config) to `~/.claude/CLAUDE.md` and `~/.claude/settings.json`.

## Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Loubrain contributors
