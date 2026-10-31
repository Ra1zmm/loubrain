---
name: loubrain
description: Run this FIRST, before ANY substantial build or change work — before writing code or creating files. Triggers on building, creating, starting, making, or scaffolding a project, app, tool, website, script, or bot, AND on improving, refactoring, rewriting, redesigning, restructuring, migrating, modernizing, or extending existing work, plus adding any non-trivial feature or making any big change. Triggers on these intents in ANY language (crear, créer, erstellen, criar, создать, 创建, 作成, बनाना, إنشاء, oluşturmak, membuat…), not only English. No keyword or slash command is needed — intent alone triggers it. Loubrain runs the whole front end of the work. It updates installed tools, recalls past sessions, interviews the user to pin the real goal, inventories the skills and agents they already own, researches the web for anything missing, elects the single best pick per capability, then shows one roster and waits for the user's green light before installing anything or building.
---

# Loubrain

The master skill. It runs before everything else and decides how the work will be done: what the goal really is, which of the user's skills and agents will do each job, and what is worth installing before starting.

Goal first, toolset second, code last. Never write project code, and never install anything, before the user approves the roster.

## When this runs (automatic — no keyword, any language)

Loubrain fires on **intent**, not vocabulary. The user will almost never name it, and waiting to be named is a failure to run.

- **New work** — build, create, start, make, scaffold, set up, bootstrap a project, app, site, tool, script, bot, service, feature, or MVP.
- **Changing existing work** — improve, refactor, rewrite, redesign, restructure, rearchitect, overhaul, revamp, modernize, migrate, port, upgrade.
- **Adding to existing work** — a new feature, subsystem, or module.
- **Any big change** — framed as major, large, from scratch, or spanning multiple files.

**Any language counts.** Translate before judging, never pattern-match English. If the user's request means *build / create / start / change / improve* in their language, that is the trigger — Spanish *crea/construye*, French *crée/construis/refais*, German *erstelle/baue*, Portuguese *cria/constrói*, Italian *crea*, Russian *создай/сделай*, Chinese *创建/做一个/重构*, Japanese *作って/作成*, Korean *만들어*, Hindi *बनाओ*, Arabic *أنشئ/اصنع/ابنِ*, Turkish *oluştur/yap*, Indonesian *buat*, Dutch *maak*, Polish *stwórz*, and every other language the same way. Reply in the user's language.

The one exception: a genuinely trivial, contained edit — a typo, one variable rename, a single config value. When a change sits between trivial and substantial, run Loubrain.

For change work rather than a new project, read "the project" below as "the change".

## Speak as one voice

Loubrain composes other skills internally. To the user this is **one process** — Loubrain. Describe what is happening in plain terms ("pinning down the goal", "checking what's installed", "comparing the options"), not by narrating machinery ("now invoking X", "the Y skill says…").

This is about presentation, not concealment: keep the internals out of routine narration, but if the user asks directly what Loubrain uses, answer honestly.

## Phase 0 — Recall before you spend anything

Start by loading what is already known. A build that re-derives context it already had is the single most expensive habit there is.

Pick the user's **session-memory** capability now, with a quick look — not the full election below. Scan the available-skills list already in context for anything that persists knowledge across sessions: a memory plugin, a knowledge-graph or knowledge-base skill, a session-notes or learning skill. Take the obvious one; if two look equally good, take either and move on. This is a cheap lookup because it runs before you know what the project needs — the considered election in Phase 2 is for capabilities where the choice actually depends on the goal.

Search it for this project or a related past session, and carry forward the goal, decisions, and roster it already holds.

Then keep using it for the rest of the run: persist the goal and roster once approved, and each significant decision as it happens, so a compaction or a new session does not lose the plan.

If the user has no memory skill, note it as a gap and fall back to a file in the project (`NOTES.md`, `PLAN.md`) that a later session can pick up.

### Keep the toolset current

Stale tools are a silent tax: an out-of-date skill holds last quarter's API, its old advice, and bugs already fixed upstream. So refresh what's installed before electing anything from it.

Run `npx skills update` once at the start of the run. Then record that it ran, and **skip it entirely if it has already run in the last 24 hours** — a network round trip in front of every request is exactly the kind of overhead Loubrain is supposed to remove. A marker file in the config directory (`<config>/.loubrain-updated`) is enough: check its modification time first, touch it after.

Three things to know before you rely on it:

- **There is no dry run.** `npx skills check` sounds read-only but applies the updates too, so there is no way to preview and then ask. This is why the step is scoped to *updating what the user already installed* — tools they have already chosen and trusted.
- **Updating is not installing.** This step never adds anything new. A skill the user does not have still goes through Phase 3 and still needs an explicit yes.
- **It must never block the build.** Individual updates fail (an upstream repo moves, a network blip), `npx` may be missing, the machine may be offline. Note what failed in one line and carry on — a stale tool is a far smaller problem than a kickoff that cannot start.

Report the result in one line, not a wall of package output: how many updated, and anything that failed.

## Phase 1 — Interview until the goal is real

The wrong goal elects the wrong toolset and builds the wrong thing, so this phase decides everything downstream.

Run a **relentless interview**, using the user's best installed questioning skill for it — `grilling` if present (note: `grill-me` is user-invocable only, so call `grilling`). Follow that skill's own cadence. Its method, which Loubrain adopts wherever it isn't installed:

- **Walk the decision tree**, resolving dependencies in order — each answer determines what is worth asking next.
- **Ask dependent decisions one at a time**, waiting for the answer before the next, because you cannot sensibly ask the follow-up until you know the first answer. Questions that are genuinely independent of each other can go together in a single `AskUserQuestion` call (it takes up to 4) — that is one round trip instead of four, and round trips cost the user both time and credits. The rule is dependency, not ceremony: never batch a question whose *options* depend on another answer in the same batch.
- **Every question carries your recommended answer**, so the user can simply accept it. In `AskUserQuestion`, put the recommendation first and mark it `(Recommended)`. Without that tool, ask in plain text and state your recommendation inline.
- **Look up facts, ask only for decisions.** Anything discoverable from the filesystem, the repo, or a tool is yours to find. The judgment calls are the user's.
- **Do not act until you have a shared understanding** of what "done" looks like.

Cover what would change the build or the toolset: audience and platform, scale and stakes, stack preferences and hard constraints, must-haves versus nice-to-haves, delivery and deadline, and what "best result" means to *them* — speed, polish, low cost, learnability.

**Scale the interview to the job.** A one-file script may be clear after a single question; a production app with users and a deadline earns a real interview. Over-questioning a small task burns the user's patience and credits on a decision that had one sensible answer. Stop when another question would not change what you build, and state the rest as one-line assumptions.

## Phase 2 — Build the roster: owned skills first, then the world

For every capability the work needs — frontend/design, API, database, testing, deployment, docs, and so on — pick the single best **skill** and, where relevant, the best **agent**.

Two capabilities are on every roster regardless of the project, because both fail silently when missing:

- **Session memory** — already chosen in Phase 0. Carry that pick straight onto the roster; do not re-elect it.
- **Credit/token efficiency** — anything that audits context-window usage, advises compaction, tracks token spend, or routes work between models by cost. Pick it the same cheap way, since it also doesn't depend on the goal. Follow it during the build: compact at phase boundaries, keep context lean, push mechanical work to cheaper models. Loubrain's planning cost has to be earned back.

Neither needs the full election — the goal doesn't change which memory or cost skill is best. Everything below is for the capabilities where it does.

### 2a. What the user already owns comes first

Installed skills win by default: they cost nothing, need no approval, and are already trusted. Only look outward once you are sure nothing installed fits.

Find candidates cheaply — never bulk-read the library:

1. The session's **available-skills** and **available-agents** lists, already in context for free.
2. `ListSkills` / `SearchSkills` where available.
3. Otherwise `Grep` skill frontmatter for capability keywords:
   `Grep pattern:"react|frontend|design" path:"<skills-dir>" glob:"SKILL.md"` — resolve `<skills-dir>` as `$CLAUDE_CONFIG_DIR/skills` when that variable is set, else `~/.claude/skills`. Never assume `~/.claude`; a wrong path returns nothing, which looks exactly like "no candidates exist".

Match on **what a skill does**, read from its description — never on its name. Names vary wildly between setups.

Check invocability too: a skill marked `disable-model-invocation: true` cannot be called programmatically, so either elect an equivalent that can be, or adopt its method inline. Never put a skill on the roster you cannot actually run.

### 2b. Only then, search outward for what is missing

**`find-skills` is the default way to search.** For any capability with no installed candidate, reach for it first — it is purpose-built for exactly this question, and it checks the skills.sh leaderboard before searching, so install counts and provenance come back with the results instead of having to be chased down separately. Its CLI (`npx skills find <query>`) searches the open skill ecosystem directly.

Fall back only when it genuinely cannot answer: `skill-scout` for local and marketplace sources, `SearchPlugins` / `SuggestPluginInstall` for plugins, or direct research across GitHub, Reddit, and dev blogs for anything outside the skill ecosystem entirely. If `find-skills` is not installed, use whatever discovery skill is, and say which.

Judge external candidates harder than installed ones — they are unvetted code from strangers. Prefer maintained, popular, clearly-scoped skills; treat a high install count as evidence and anything with very few installs as a risk worth naming. Always say where each came from.

### 2c. Elect when several compete

Per capability, count real candidates — only ones that actually exist, never invented names:

- **0** → a **gap**; carry it to the roster as a suggestion.
- **1** → use it. No election; a one-option decision needs no research.
- **2+** → **elect.** This is the point of Loubrain: when four design skills or three testing skills overlap, something has to choose deliberately.

Run the election in ONE subagent pinned to a mid-tier model — set `model: sonnet` explicitly on the Agent call, using the alias rather than a versioned ID so it survives model releases. Don't run it inline on the main model, and don't let the subagent inherit the parent's. Use a `general-purpose` agent so it has web tools. For each contest it must:

1. **Read what each candidate actually does** — its own `SKILL.md` or agent description.
2. **Check external evidence** — web search plus Reddit and dev-blog signal on which approach is better regarded and more current *for this kind of work*.
3. **Score 1-5** on: *goal match*, *specificity* to this stack, *coverage* alone, and *external verdict*.

Highest total wins; ties go to the more specific candidate. One winner per capability — never two, which would give conflicting instructions mid-build. Note the runner-up and the deciding evidence in one line each.

If web search is unavailable, still elect on the internal criteria and say the pick had no external backing. If no capability has 2+ candidates, skip the subagent entirely.

### When the library is thin

Loubrain works with few or no installed skills — it just shifts weight. Skip the election, keep the brief short, build with your own general abilities, and cap suggestions at the two or three that would genuinely change the outcome. A first-time user asking for a landing page does not want a shopping list before anything gets built.

## Phase 3 — One roster, then wait

Show the user a single brief and **stop**. Nothing is installed and nothing is built before they answer.

```
## Kickoff: <project>
**Goal:** <1-2 sentences>

| Capability | Skill | Agent | Why |
|---|---|---|---|
| Session memory | ... | — | one line |
| Credit efficiency | ... | — | one line |
| <capability> | ... | ... or — | one line (cite evidence where elected) |

**Not installed — worth adding:** <name — what it improves — where it comes from>, or "none"
```

Every entry must actually exist. Separate clearly what is **already installed** (ready to go) from what would need **installing** (needs their permission, comes from outside).

End with a direct ask: *"Green light to build with this?"* Then wait. The user may swap a pick, drop a capability, or decline an install — all fine. **Never install anything without an explicit yes**, and if they decline, cover that capability with general abilities and say so.

## Phase 4 — Build (only after the green light)

Once approved, build — and **invoke the roster yourself**. The approved roster is the authorization: the user already decided in Phase 3, so never wait for them to type `/skill-name`, never ask "should I use X now?" for something already approved, and never quietly skip an approved pick to work freehand because invoking it felt like ceremony.

Announce each step in plain language as Loubrain, not as a tool handoff.

Keep the two always-on capabilities working throughout — memory persisting decisions as they happen, the cost capability applied at phase boundaries. If a pick turns out to be a bad fit mid-build, say so and name the replacement rather than dropping it silently.
