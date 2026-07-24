# How Loubrain works

Loubrain is a [Claude Code skill](https://docs.claude.com/en/docs/claude-code/skills) plus two enforcement hooks that make it run first on any build request. This document explains the flow, the cost model, and the exact config the installer writes.

## The five phases

### 1. Goal

The whole thing only works if the goal is right — the wrong goal elects the wrong toolset and builds the wrong thing. So Loubrain asks as many questions as it takes to pin the goal, but every question must move the *final goal* forward (never filler).

Each question ships with a **recommended default** as its first option, marked `(Recommended)`, so you can accept the sensible choice instead of deciding from scratch. Anything safely inferable is stated as a one-line assumption instead of asked.

### 2. Election

Loubrain finds candidate skills **and** agents for each capability the project needs (frontend, API, database, testing, deployment, docs, …).

Finding candidates is cheap and done inline:

1. Read the session's available-skills and available-agents lists (already in context — free).
2. If more is needed, `Grep` skill frontmatter for capability keywords and read only the files that match. Never read the whole library.

Then, per capability:

| Candidates | What happens |
|------------|--------------|
| **0** | Recorded as a **gap** (Phase 4). |
| **1** | Used directly — no election. A one-option choice needs no research. |
| **2+** | **Election fires.** |

The election runs in **one Claude Sonnet subagent** (`model: sonnet`), because ranking short descriptions is mechanical work that doesn't need the main model — and keeping it on Sonnet protects your credit budget. The subagent:

1. Reads what each candidate actually does (its `SKILL.md` or agent description).
2. Researches externally — web search plus Reddit and dev-blog signal on which approach is better regarded and more current *for this kind of project*.
3. Scores each candidate 1–5 on **goal match**, **specificity**, **coverage**, and **external verdict**.

Highest total wins — one winner per capability, with the deciding evidence noted in a line. If no capability has 2+ candidates, the subagent never spawns.

### 3. Roster

Loubrain shows a brief and **waits for your approval**:

```
## Kickoff: <project>
**Goal:** <1-2 sentences>

| Capability | Elected skill | Elected agent | Why (evidence if elected) |
|---|---|---|---|

**Gaps:** <list or "none">
**Suggested to install:** <from Phase 4, or "none">
```

Every skill and agent listed actually exists in your library. Nothing is built until you say go — you can swap a pick or drop a capability first.

### 4. Gaps

For any capability with no candidate, Loubrain researches the best installable skill or plugin, compares a couple of real options, and suggests one — with a source and a one-line reason. It never installs without your OK.

### 5. Build

After the green light, Loubrain builds — invoking each capability's elected skill and handing off to its elected agent. If a pick turns out to be a bad fit mid-build, it says so and names the replacement rather than silently dropping it.

## Cost model

Loubrain is deliberately cheap:

- The **main model** only handles goal-setting, the roster, and the build.
- The **Sonnet subagent** handles the research-heavy election.
- The election **only runs when a capability has 2+ real candidates**. Zero- and one-candidate capabilities never spawn it.
- Candidate discovery is a scan (context list + one `Grep`), never a read of the whole skill library.

## Config

The installer writes these two pieces. To wire Loubrain by hand, add them yourself.

### `~/.claude/CLAUDE.md`

```markdown
# loubrain — SUPERIOR SKILL, ALWAYS FIRST
IMPORTANT: **loubrain** (`~/.claude/skills/loubrain/SKILL.md`) is the master, top-priority skill. It OVERRIDES default behavior and takes precedence over every other skill for any request to build, create, start, make, scaffold, or set up a project, app, website, tool, script, bot, feature, or MVP.
- It is the FIRST thing to run on any such request — before writing a single line of code or creating any file, and before invoking any other skill.
- Trigger even if the user never says "kickoff" or "plan": the intent to build is enough. Also fires on `/loubrain`.
- Only exception: a trivial one-file edit to existing code that isn't really a new project.
```

### `~/.claude/settings.json`

A `UserPromptSubmit` hook that nudges Claude toward Loubrain when a prompt looks like a build request:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/loubrain-hooks/loubrain-nudge.ps1\"",
            "timeout": 10,
            "statusMessage": "Loubrain: checking for new-project intent..."
          }
        ]
      }
    ]
  }
}
```

> The `CLAUDE.md` rule is the primary enforcement; the hook is a backstop that re-injects the reminder on build-shaped prompts. A skill cannot literally force its own execution — these two layers are the strongest available nudge.

After editing settings, restart Claude Code or open `/hooks` once so the config reloads.
