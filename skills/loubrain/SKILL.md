---
name: loubrain
description: Run this FIRST before starting, building, creating, or scaffolding ANY new project — before writing any code or files. Use whenever the user asks to build/create/start/make a project, app, tool, website, script, bot, or MVP, even if they never say "kickoff" or "plan". This is the master skill that decides the whole toolset the project builds with: it extracts the user's true end goal, then for each capability picks the single best skill AND agent from the owner's installed library — when several compete for the same goal (e.g. 4-5 design skills) it runs a Sonnet 5 election backed by web search and Reddit/blog evidence to choose the best one. Outputs the full roster of chosen skills and agents, suggests any missing skill worth installing, and only starts building after the user gives the green light.
---

# Loubrain

This is the superior/master skill — it runs before everything and decides which of the owner's skills and agents the project will actually build with, so the build uses the best tool for each job instead of whatever gets grabbed by default.

Goal first, toolset second, code last. Never write project code before finishing the phases below, and never start the build until the user approves the roster. The visible output is a short kickoff brief, then — after approval — the actual build.

## Phase 1 — Understand the goal (ask thoroughly)

The whole skill only works if the goal is nailed — the wrong goal elects the wrong toolset and builds the wrong thing. So ask as many questions as it takes to fully pin the goal. Don't ration questions to save a turn; a few extra questions now are far cheaper than building on a guess. But every question must move the *final goal* forward — never ask filler, never ask what you can infer from the request or defaults.

- Restate the project in 1-2 sentences: final deliverable, who it's for, what "done" looks like.
- Name the end goal behind the request — what the user will actually *do* with the result.
- Ask about anything still unknown that would change the build or the toolset election, e.g.:
  - Who uses it and on what — audience, device, platform (web/mobile/desktop/CLI).
  - Scale and stakes — throwaway vs. production, expected users, must it scale.
  - Stack/tools the user already wants or must avoid.
  - Must-have features vs. nice-to-have; what's explicitly out of scope.
  - How it's delivered — hosting, deadline, budget, who maintains it.
  - What "best result" means to *them* — speed to ship, polish, low cost, learnability.

Use AskUserQuestion (max 4 per call — batch them, call again for more rounds until the goal is fully clear). Keep each question short and goal-relevant, with concrete options plus room to type their own.

**Every question carries a suggestion.** For each question, make your recommended answer the **first** option and mark it `(Recommended)` in the label — the best default for this project given what you know so far, so the user can just accept it instead of deciding from scratch. Base the suggestion on the goal and sensible defaults for this kind of project; the other options are the real alternatives. The user always keeps "Other" to type their own.

Only stop asking once one more question wouldn't change what you build. Anything still safely inferable → state it as a one-line assumption instead of asking.

## Phase 2 — Choose the best skill AND agent per capability

For every capability the project needs (frontend/design, API, database, testing, deployment, docs, and so on), pick the single best **skill** and, where relevant, the single best **agent** from the owner's installed library. Agents matter as much as skills here — e.g. a React project's review capability should elect the best reviewer agent, not be left to chance.

### Find candidates (cheap, inline — no subagent)

1. Start from what's already in context for free: the session's **available-skills list** (name + one-liner per installed skill) and the **available-agents list** (name + description per agent). Enough to spot candidates for most capabilities.
2. When more is needed, **Grep frontmatter for capability keywords** (`Grep pattern:"react|frontend|design" path:"~/.claude/skills" glob:"SKILL.md"`) and read only the files that match — one Grep beats hundreds of Reads. Never read all 400+ skill files.

For each capability, count real candidates (skills and agents that actually exist — never invent names):

- **0 candidates** → it's a **gap**. Record for Phase 4.
- **1 candidate** → use it. No election — a one-option decision doesn't need research or a subagent.
- **2+ candidates competing for the same goal** → **the election fires.** This is the whole point of the skill: a library like this has 4-5 design skills, several test skills, multiple reviewer agents — only here is there a real choice worth researching.

### The election (only for capabilities with 2+ candidates)

Run it in ONE subagent pinned to **Sonnet 5** — set `model: sonnet` explicitly on the Agent call (don't run it inline on the main model, don't let it inherit the parent model). Sonnet is capable enough for this comparison and keeps the research off the pricier model to protect the credit budget. Use a `general-purpose` agent so it has web tools.

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
| ...        | ...           | ... or —      | one line |

**Gaps:** <list or "none">
**Suggested to install:** <from Phase 4, or "none">
```

Every skill and agent in the roster must actually exist in the installed library. End with a clear ask: "Green light to build with this roster?" Do not start Phase 5 until the user says yes — they may swap a pick or drop a capability first.

## Phase 4 — Gap suggestions

Only when Phase 2 found gaps:

- Research (web search) which installable skill or plugin best covers each gap. Same election mindset: compare 2-3 real options, pick the best, say why in one line.
- Suggest to the user: skill name, where to get it (repo/marketplace), what it improves.
- Never install without the user's OK. If declined, cover the gap with general abilities and say so in the brief.

## Phase 5 — Build (only after green light)

Once the user approves the roster, start building. At each build phase, invoke that capability's elected skill via the Skill tool and hand off to its elected agent where one was chosen. Don't silently drop roster picks — if one proves a bad fit mid-build, say so and name the replacement.
