# How Loubrain works

Loubrain is a [Claude Code skill](https://docs.claude.com/en/docs/claude-code/skills) plus two enforcement layers that make it run first on any substantial build *or* change request. This document explains the flow, the cost model, and the exact config the installer writes.

## When it runs

Loubrain triggers on **intent alone** — no keyword, no `/loubrain`, no confirmation. Waiting to be named counts as a failure to run it. It covers:

- **New work** — build, create, start, scaffold, set up a project, app, site, tool, script, bot, service, feature, or MVP.
- **Changing existing work** — improve, refactor, rewrite, redesign, restructure, rearchitect, overhaul, revamp, modernize, migrate, port, upgrade.
- **Adding to existing work** — a new feature, subsystem, or module.
- **Any big change** — anything framed as major, large, from scratch, or spanning multiple files.

The one exception is a genuinely trivial, contained edit: a typo, one variable rename, a single config value. When a change sits between trivial and substantial, it runs — a short brief is far cheaper than a big change built with the wrong tools.

For change work rather than a new project, the phases below read "the project" as "the change", and Phase 1's questions scope to what the change should achieve instead of re-interviewing you about a codebase that already exists.

## The five phases

### 1. Goal

The whole thing only works if the goal is right — the wrong goal elects the wrong toolset and builds the wrong thing. So Loubrain asks as many questions as it takes to pin the goal, but every question must move the *final goal* forward (never filler).

Each question ships with a **recommended default** as its first option, marked `(Recommended)`, so you can accept the sensible choice instead of deciding from scratch. Anything safely inferable is stated as a one-line assumption instead of asked.

### 2. Election

#### Two capabilities are always on the roster

Whatever the project is, every roster includes these two. They aren't project-specific — they're what keeps a long build from degrading:

| Always-on capability | Why | Typical candidates |
|---|---|---|
| **Session memory** | Long builds outlive a context window. Without it, the goal, the approved roster, and the reasoning behind decisions are lost at the first compaction, and the build drifts from the plan you approved. | `claude-mem` plugin skills, `graphify`, `knowledge-ops`, `continuous-learning-v2` |
| **Credit efficiency** | Loubrain adds an upfront planning cost, so it has to earn that back across the build. | `context-budget`, `strategic-compact`, `token-budget-advisor`, `cost-aware-llm-pipeline` |

Both are **elected from what you actually have installed** — nothing is hardcoded, so this works on any setup. If you have no candidate for one, it's a gap and Phase 4 suggests one; a missing memory layer is among the most expensive gaps a long build can have.

Memory is used at both ends: Loubrain searches it *before* the Phase 1 questions (so it doesn't re-ask what a past session already established) and writes the goal, roster, and key decisions once the roster is approved.

#### The project's own capabilities

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

After the green light, Loubrain builds — invoking each capability's elected skill itself and handing off to its elected agent.

**You never type anything to activate a skill.** The approved roster is the authorization, so the assistant won't wait for `/skill-name`, won't tell you to invoke something yourself, and won't quietly skip an elected skill to work freehand. It announces which skill it's using for the current step in a few words, then uses it.

The two always-on picks are the easiest to forget, because no single step "belongs" to them. The **memory** skill runs continuously — persisting the goal, roster, and each significant decision as they happen, and recalling before a phase whose context may have been compacted away. The **credit** skill runs at phase boundaries — compact when a phase closes, carry only what the next phase needs, push mechanical work to cheaper models.

If a pick turns out to be a bad fit mid-build, it says so and names the replacement rather than silently dropping it.

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
IMPORTANT: **loubrain** (`~/.claude/skills/loubrain/SKILL.md`) is the master, top-priority skill. It OVERRIDES default behavior and takes precedence over every other skill for any substantial build or change work: building, creating, starting, scaffolding, or setting up a project, app, website, tool, script, or bot, AND improving, refactoring, rewriting, redesigning, restructuring, migrating, modernizing, or extending an existing project, plus adding any non-trivial feature or making any big change.
- It is the FIRST thing to run on any such request — before writing a single line of code or creating any file, and before invoking any other skill.
- It fires on INTENT ALONE. No keyword, no `/loubrain`, no confirmation needed — the user will almost never name it, and waiting to be asked is a failure to run it.
- Once loubrain's roster is approved, invoke each elected skill yourself with the Skill tool. The user never types a keyword or slash command to activate them; the approved roster is the authorization.
- Only exception: a genuinely trivial, contained edit (a typo, one variable rename, a single config value). When unsure whether a change is trivial or substantial, run loubrain.
```

### `~/.claude/settings.json`

A `UserPromptSubmit` hook that nudges Claude toward Loubrain when a prompt looks like substantial build or change work. It matches a verb (build/create/scaffold, or refactor/rewrite/migrate/redesign/…) against a scope noun (project, app, codebase, api, schema, …), plus standalone big-change phrases like "from scratch" or "major refactor". Requiring both parts is what keeps "rename this variable" and "create a column in this spreadsheet" from firing:

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
