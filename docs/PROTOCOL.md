# The Loubrain protocol (tool-agnostic)

This is the canonical description of what Loubrain does, written without naming
any specific tool's API. Each assistant-specific file (`skills/loubrain/SKILL.md`
for Claude Code, `AGENTS.md` for Codex-family tools, `GEMINI.md` for Gemini CLI,
`.cursor/rules/loubrain.mdc` for Cursor) is an adaptation of this protocol into
that tool's native convention. If you're porting Loubrain to a new assistant,
start here.

## When it runs

Before writing any code or creating any file, on any **substantial build or
change work**:

- **New work** — build, create, start, make, scaffold, set up, bootstrap a
  project, app, site, tool, script, bot, service, feature, or MVP.
- **Changing existing work** — improve, refactor, rewrite, redesign,
  restructure, rearchitect, overhaul, revamp, modernize, migrate, port, upgrade.
- **Adding to existing work** — a new feature, subsystem, or module.
- **Any big change** — anything framed as major, large, from scratch, or
  spanning multiple files or areas.

It runs on **intent alone**, in **any language**. Translate the request before
judging it; never pattern-match English. If the user's words mean *build /
create / start / change / improve* in their language, that is the trigger. No
keyword, slash command, or confirmation is required — waiting to be asked is a
failure to run. Reply in the user's language.

Skip only for a genuinely trivial, contained edit: a typo, one variable rename,
a single config value. When unsure, run the protocol — a short brief costs far
less than doing a big change with the wrong tools.

For change work rather than a new project, read "the project" below as "the
change".

## Speak as one voice

This protocol composes other capabilities internally. To the user it is **one
process**. Describe what is happening in plain terms ("pinning down the goal",
"checking what's installed", "comparing the options"), not by narrating
machinery ("now invoking X"). This is presentation, not concealment: keep
internals out of routine narration, but answer honestly if asked directly.

## Phase 0 — Recall before spending anything

Load what is already known. Re-deriving context you already had is the single
most expensive habit there is.

Pick the user's **session-memory** capability now, with a quick look rather
than the considered election below — anything that persists knowledge across
sessions (a memory plugin, a knowledge-graph or knowledge-base tool, a
session-notes or learning skill). Take the obvious one; the best memory tool
does not depend on what is being built, so there is nothing to research yet.
Search it for this project or a related past session and carry forward the
goal, decisions, and plan it holds.
Keep writing to it for the rest of the run, so a compaction or a new session
does not lose the plan.

With no memory tool available, note it as a gap and fall back to a file in the
project (`NOTES.md`, `PLAN.md`) that a later session can pick up.

## Phase 1 — Interview until the goal is real

The wrong goal elects the wrong toolset and builds the wrong thing, so this
phase decides everything downstream. Run a relentless interview, using the
user's best questioning capability if they have one. The method:

- **Walk the decision tree**, resolving dependencies in order — each answer
  determines what is worth asking next.
- **Ask dependent decisions one at a time**, waiting for each answer, since you
  cannot sensibly frame the follow-up until you have it. Genuinely independent
  questions can go together in one prompt — a round trip costs the user time
  and budget. The rule is dependency, not ceremony.
- **Every question carries your recommended answer**, so the user can simply
  accept it. Where the interface supports options, put the recommendation first
  and mark it as recommended.
- **Look up facts, ask only for decisions.** Anything discoverable from the
  filesystem, the repo, or a tool is yours to find. The judgment calls are the
  user's.
- **Do not act until you have a shared understanding** of what "done" means.

Cover what would change the build or the toolset: audience and platform, scale
and stakes, stack preferences and hard constraints, must-haves versus
nice-to-haves, delivery and deadline, and what "best result" means to *them*.

**Scale the interview to the job.** A one-file script may be clear after a
single question; a production app earns a real interview. Over-questioning a
small task burns patience and budget on a decision that had one sensible
answer. Stop when another question would not change what you build, and state
the rest as one-line assumptions.

## Phase 2 — Build the plan: owned tools first, then the world

For each capability the work needs (frontend, API, database, testing,
deployment, docs…), pick the single best tool and, where relevant, the best
sub-agent.

Two capabilities are on every plan regardless of the project, because both fail
silently when missing: the **session memory** already picked in Phase 0 (carry
that pick forward, do not re-elect it), and a **cost/token efficiency**
capability (anything that audits context usage, advises
compaction, tracks spend, or routes work between models by cost). Follow the
second during the build — compact at phase boundaries, keep context lean, push
mechanical work to cheaper models. This protocol's planning cost has to be
earned back.

### 2a. What the user already has comes first

Installed tools win by default: they cost nothing, need no approval, and are
already trusted. Only look outward once nothing installed fits.

Find candidates cheaply — never bulk-read the whole library. Use whatever
low-cost inventory your host offers (a list of available capabilities already
in context, a search command), then a targeted keyword search, and only open a
full definition when a name plus description can't settle it.

Match on **what a tool does**, read from its description — never on its name.
Names vary wildly between setups. Check that you can actually invoke it, too:
some tools are user-invocable only. Never plan around something you cannot run.

### 2b. Only then, search outward for what is missing

For any capability with no local candidate, search the ecosystem — a skill- or
plugin-discovery capability if the user has one, otherwise direct research
across GitHub, Reddit, and dev blogs.

Judge external candidates harder than installed ones: they are unvetted code
from strangers. Prefer maintained, popular, clearly-scoped options, and say
where each came from.

### 2c. Elect when several compete

Per capability, count real candidates — only ones that exist, never invented:

- **0** → a gap; carry it to the plan as a suggestion.
- **1** → use it. No election; a one-option decision needs no research.
- **2+** → **elect.** This is the point: when several tools overlap, something
  has to choose deliberately.

Compare what each candidate actually does, check external evidence (web search,
community discussion) on which approach is better regarded for this kind of
work, and score on goal match, specificity to this stack, coverage alone, and
external verdict. Highest total wins; ties go to the more specific. One winner
per capability — never two, which would give conflicting instructions mid-build.
Note the runner-up and the deciding reason in a line each.

If your host can delegate this comparison to a cheaper or faster model, do so —
it is mechanical work. Without web access, still elect on internal criteria and
say the pick had no external backing.

### When the library is thin

This works with few or no installed tools; it just shifts weight. Skip the
election, keep the brief short, build with your own general abilities, and cap
suggestions at the two or three that would genuinely change the outcome. A
first-time user asking for a landing page does not want a shopping list before
anything gets built.

## Phase 3 — One plan, then wait

Show a single brief and **stop**. Nothing is installed and nothing is built
before the user answers.

```
Goal: <1-2 sentences>
Plan:
  <capability> -> <chosen tool>  (<why, one line>)
  ...
Not installed - worth adding: <name - what it improves - where it comes from>, or "none"
```

Every entry must actually exist. Separate clearly what is **already installed**
(ready to go) from what would need **installing** (needs permission, comes from
outside).

End with a direct ask — *"Green light to build with this?"* — and wait. The
user may swap a pick, drop a capability, or decline an install. **Never install
anything without an explicit yes**; if they decline, cover that capability with
general abilities and say so.

## Phase 4 — Build (only after the green light)

Once approved, build — and activate the plan yourself. The approved plan *is*
the authorization: never wait for a keyword or slash command, never tell the
user to invoke something themselves, and never quietly skip an approved tool to
work freehand because invoking it felt like ceremony.

Announce each step in plain language, as one process.

Keep the two always-on capabilities working throughout — memory persisting
decisions as they happen, the cost capability applied at phase boundaries. If a
pick turns out to be a bad fit mid-build, say so and name the replacement
rather than dropping it silently.
