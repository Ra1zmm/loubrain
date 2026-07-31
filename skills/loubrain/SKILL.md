---
name: loubrain
description: Run this FIRST, automatically, before ANY substantial build or change work — before writing code or creating files. Triggers on building/creating/starting/scaffolding a new project, app, tool, website, script, or bot, AND on improving, refactoring, rewriting, redesigning, restructuring, migrating, modernizing, or extending an existing project, plus adding any non-trivial feature or making any big/major change. No keyword or slash command is ever required — the user's intent to build or substantially change something is the trigger, even if they never say "loubrain", "kickoff", or "plan". This is the master skill that decides the whole toolset the work uses: it extracts the user's true end goal, then for each capability picks the single best skill AND agent from the owner's installed library — when several compete for the same goal (e.g. multiple design skills) it runs a cheap Sonnet subagent election backed by web search and community evidence to choose the best one. Every roster also includes two capabilities regardless of the project: a session-memory skill so the goal and plan survive compaction, and a credit/token-efficiency skill so the build stays cheap. Outputs the full roster of chosen skills and agents, suggests any missing skill worth installing, and only starts work after the user gives the green light. Works with any size skill library, including an empty one.
---

# Loubrain

This is the superior/master skill — it runs before everything and decides which of the owner's skills and agents the work will actually use, so the build uses the best tool for each job instead of whatever gets grabbed by default.

Goal first, toolset second, code last. Never write project code before finishing the phases below, and never start the build until the user approves the roster. The visible output is a short kickoff brief, then — after approval — the actual build.

## When this runs (automatic — no keyword needed)

Loubrain is not something the user invokes. It fires on **intent**, and the user will almost never name it. Treat the presence of any of these as the trigger, with no keyword, no `/loubrain`, and no confirmation that the skill should run:

- **New work** — build, create, start, make, scaffold, set up, bootstrap, spin up a project, app, site, tool, script, bot, service, feature, or MVP.
- **Changing existing work** — improve, refactor, rewrite, redesign, restructure, rearchitect, overhaul, revamp, modernize, migrate, port, or upgrade an existing project or a significant part of one.
- **Adding to existing work** — add a feature, add a subsystem, extend the project with something new.
- **Any big change** — anything the user frames as major, large, from scratch, or spanning multiple files/areas, even if they don't use one of the verbs above.

The one exception: a genuinely trivial, contained edit to existing code — fix this typo, rename this variable, adjust this one function, tweak a config value. Those don't need a toolset election. When you're unsure whether a change is trivial or substantial, run Loubrain; a short kickoff brief costs far less than building a big change with the wrong tools.

For change work (not a brand-new project), the phases below still apply — read "the project" as "the change", and scope Phase 1's questions to what the change is meant to achieve rather than re-interviewing the user about a codebase that already exists.

## Phase 1 — Understand the goal (ask thoroughly)

The whole skill only works if the goal is nailed — the wrong goal elects the wrong toolset and builds the wrong thing. So ask as many questions as it takes to fully pin the goal. Don't ration questions to save a turn; a few extra questions now are far cheaper than building on a guess. But every question must move the *final goal* forward — never ask filler, never ask what you can infer from the request or defaults.

**Scale the interview to the job.** "As many as it takes" is bounded by what's actually at stake. A one-file utility script is usually clear after a single round — sometimes after none, if the request is already specific. A production app with users, hosting, and a deadline earns several rounds. Over-interviewing a small task is its own failure: it burns the user's patience and credits on a decision that had one sensible answer. If you catch yourself asking about scale and hosting for a throwaway script, stop and state assumptions instead.

**Check memory before asking.** If a session-memory skill is installed (see Phase 2), search it first for this project or a related past session. Prior goals, decisions, and rosters answer some questions outright — re-asking what the user already told you in an earlier session wastes their time and your credits.

- Restate the project in 1-2 sentences: final deliverable, who it's for, what "done" looks like.
- Name the end goal behind the request — what the user will actually *do* with the result.
- Ask about anything still unknown that would change the build or the toolset election, e.g.:
  - Who uses it and on what — audience, device, platform (web/mobile/desktop/CLI).
  - Scale and stakes — throwaway vs. production, expected users, must it scale.
  - Stack/tools the user already wants or must avoid.
  - Must-have features vs. nice-to-have; what's explicitly out of scope.
  - How it's delivered — hosting, deadline, budget, who maintains it.
  - What "best result" means to *them* — speed to ship, polish, low cost, learnability.

Use AskUserQuestion where it's available (max 4 per call — batch them, call again for more rounds until the goal is clear). Keep each question short and goal-relevant, with concrete options plus room to type their own. If that tool isn't available in the environment, ask the same questions as a short numbered list in your reply — the questions matter, the widget doesn't.

**Every question carries a suggestion.** For each question, make your recommended answer the **first** option and mark it `(Recommended)` in the label — the best default for this project given what you know so far, so the user can just accept it instead of deciding from scratch. Base the suggestion on the goal and sensible defaults for this kind of project; the other options are the real alternatives. The user always keeps "Other" to type their own.

Only stop asking once one more question wouldn't change what you build. Anything still safely inferable → state it as a one-line assumption instead of asking.

## Phase 2 — Choose the best skill AND agent per capability

For every capability the project needs (frontend/design, API, database, testing, deployment, docs, and so on), pick the single best **skill** and, where relevant, the single best **agent** from the owner's installed library. Agents matter as much as skills here — e.g. a React project's review capability should elect the best reviewer agent, not be left to chance.

### Two capabilities are ALWAYS on the roster

Regardless of what the project is, every roster must include these two. They aren't project-specific — they're what keeps a long build from degrading, so they matter *more* than any single framework choice:

**1. Session memory / continuity.** Long builds outlive a single context window. Without a memory layer, everything learned in Phase 1-2 — the goal, the elected roster, the decisions and their reasons — is lost at the first compaction, and the build drifts from the plan the user approved. Elect whatever the user has that *persists knowledge across sessions*: a memory plugin, a knowledge-graph or knowledge-base skill, a session-notes or learning skill. Use it at both ends: **recall** relevant prior context before Phase 1's questions so you don't re-ask what's already known, and **persist** the goal, roster, and key decisions once the roster is approved.

**2. Credit / token efficiency.** Loubrain adds an upfront planning cost, so it has to earn that back over the build. Elect whatever the user has that *reduces token or credit burn*: something that audits context-window usage, advises on compaction, tracks token spend, or routes work between models by cost. Then actually follow its guidance during Phase 5 — compact at phase boundaries, keep context lean, route cheap work to cheaper models.

Identify both by **what a skill does**, read from its description — not by name. Skill names vary wildly between setups, so a name-matching approach finds nothing on most machines. If the user genuinely has no candidate for one, it's a **gap** for Phase 4, not something to invent a winner for. Fall back to what's built in: for memory, write the goal and roster into a file in the project (`NOTES.md`, `PLAN.md`) so a later session can pick them up; for cost, apply the discipline directly — compact between phases and keep context tight. Say which fallback you're using in one line.

### Find candidates (cheap, inline — no subagent)

1. Start from what's already in context for free: the session's **available-skills list** (name + one-liner per installed skill) and the **available-agents list** (name + description per agent). This costs nothing and is enough for most capabilities.
2. When you need more than the one-liner, **Grep skill frontmatter for capability keywords** rather than reading files one by one — one Grep beats dozens of Reads:
   `Grep pattern:"react|frontend|design" path:"<skills-dir>" glob:"SKILL.md"`
   Resolve `<skills-dir>` before using it: it's `$CLAUDE_CONFIG_DIR/skills` when that environment variable is set, otherwise `~/.claude/skills`. Don't assume `~/.claude` — plenty of setups relocate the config directory, and grepping the wrong path silently returns nothing, which looks identical to "no candidates exist". Plugin skills live outside this directory, so treat the in-context list as the authority on what's installed.
3. Only open a full `SKILL.md` body when a name plus description genuinely can't settle whether a skill is a candidate.

Never bulk-read the whole library. On a large setup that's hundreds of files, and the scan is supposed to be the cheap part of Loubrain.

For each capability, count real candidates (skills and agents that actually exist — never invent names):

- **0 candidates** → it's a **gap**. Record for Phase 4.
- **1 candidate** → use it. No election — a one-option decision doesn't need research or a subagent.
- **2+ candidates competing for the same goal** → **the election fires.** This is the whole point of the skill: when a library holds several design skills, several testing skills, or multiple reviewer agents, only here is there a real choice worth researching.

### When the library is small or empty

Loubrain still works with few or no installed skills — it just shifts weight. Don't treat a thin library as a failure or bury the user in install suggestions:

- With **no candidates for most capabilities**, skip the election entirely, keep the brief short, and do the work with your own general abilities. Say plainly that the roster is mostly general-purpose.
- Suggest installs **only** where a skill would clearly change the outcome, and cap it at the two or three that matter most. A first-time user who asked for a landing page does not want a ten-item shopping list before anything gets built.
- The two always-on capabilities are the exception worth mentioning even on a bare setup, because their value grows with build length — but suggest, never insist, and never block the build on them.

### The election (only for capabilities with 2+ candidates)

Run it in ONE subagent pinned to a mid-tier model — set `model: sonnet` explicitly on the Agent call (don't run it inline on the main model, and don't let the subagent inherit the parent's model). Use the `sonnet` alias rather than a versioned model ID so this keeps working as models are released. Sonnet is more than capable of comparing short descriptions, and keeping the research off the top-tier model is what protects the credit budget. Use a `general-purpose` agent so it has web tools.

If web search isn't available in the environment, still run the election — score on the internal criteria alone, and say in the roster that the pick wasn't backed by external evidence. A comparison without web research still beats grabbing whichever skill triggered first.

Hand the subagent the goal statement and, for each contested capability, the competing candidates with their descriptions. For each contest it must:

1. **Understand each candidate** — what approach/tool/style it actually represents (read the candidate's own `SKILL.md` or agent description; they differ in view and context, not just name).
2. **Research externally** — WebSearch plus Reddit and dev-blog results for how each approach performs *for this kind of project*: which design style/library/testing approach is better regarded, more current, fewer footguns. This external evidence is what breaks the tie — not just the internal description.
3. **Score each candidate 1-5** on: *goal match* (serves this project's goal directly), *specificity* (specific beats generic for the stack), *coverage* (how much it handles alone), and *external verdict* (what the web/Reddit evidence favors).

Highest total wins — one winner per capability, runner-up and the deciding reason noted in one line (cite the evidence, e.g. "Reddit + docs favor shadcn approach for this stack"). Tie → the more specific candidate wins. The subagent returns the winners; the main model takes them into Phase 3 unchanged.

If **no** capability has 2+ candidates, skip the subagent entirely — assemble the roster from the lone picks and go straight to Phase 3.

Never put two skills (or two agents) on the roster for the same capability — overlapping winners give conflicting instructions mid-build.

## Phase 3 — Roster + green light

Show the user the kickoff brief and **wait for approval before building**:

```
## Kickoff: <project name>
**Goal:** <1-2 sentences>

| Capability | Elected skill | Elected agent | Why (evidence if elected) |
|---|---|---|---|
| Session memory | ...      | ... or —      | one line |
| Credit efficiency | ...   | ... or —      | one line |
| <project capability> | ...| ... or —      | one line |

**Gaps:** <list or "none">
**Suggested to install:** <from Phase 4, or "none">
```

List the two always-on capabilities (session memory, credit efficiency) first — they apply to the whole build, so they belong above the project-specific rows.

Every skill and agent in the roster must actually exist in the installed library. End with a clear ask: "Green light to build with this roster?" Do not start Phase 5 until the user says yes — they may swap a pick or drop a capability first.

## Phase 4 — Gap suggestions

Only when Phase 2 found gaps:

- Research (web search) which installable skill or plugin best covers each gap. Same election mindset: compare 2-3 real options, pick the best, say why in one line.
- Suggest to the user: skill name, where to get it (repo/marketplace), what it improves.
- Never install without the user's OK. If declined, cover the gap with general abilities and say so in the brief.

## Phase 5 — Build (only after green light)

Once the user approves the roster, start building.

**Invoke the elected skills yourself — the user never types anything.** When you reach a capability's part of the work, call its elected skill directly with the Skill tool, and hand off to its elected agent where one was chosen. The roster *is* the authorization: the user already approved these picks in Phase 3, so there is nothing left to ask and nothing left for them to trigger. Concretely, never:

- wait for the user to type `/skill-name` or say a magic word before an elected skill is used,
- tell the user to invoke a skill themselves, or ask "should I use X now?" for a skill already on the approved roster,
- quietly skip an elected skill and do the work freehand because invoking it felt like extra ceremony.

The whole point of the election is that the decision is already made — Phase 5 is execution. Announce which skill you're using for the current step in a few words so the user can follow along, then use it.

**Put the two always-on picks to work.** They're the easiest to forget, because no single step "belongs" to them:

- **Session memory** — persist the goal, the approved roster, and each significant decision as you go, not just at the end. The point is that a compaction or a new session mid-build doesn't lose the plan. Recall from it before starting a phase whose context may have been compacted away.
- **Credit efficiency** — follow its guidance at phase boundaries rather than treating it as advice-only: compact when a phase closes, keep only what the next phase needs in context, and push mechanical work (scans, comparisons, bulk edits) to cheaper models or subagents. Loubrain's planning cost has to be earned back over the build.

Don't silently drop roster picks — if one proves a bad fit mid-build, say so and name the replacement.
