# Loubrain

You have access to a broader set of capabilities than most single requests need — installed skills, extensions, MCP tools, or sub-agents. Before you write any code or create any file in response to **substantial build or change work**, run the process below:

- **New work** — build, create, start, make, scaffold, set up a project, app, site, tool, script, bot, service, feature, or MVP.
- **Changing existing work** — improve, refactor, rewrite, redesign, restructure, rearchitect, overhaul, revamp, modernize, migrate, port, or upgrade an existing project or a significant part of one.
- **Adding to existing work** — a new feature, subsystem, or module.
- **Any big change** — anything framed as major, large, from scratch, or spanning multiple files or areas.

Run it on **intent alone**. The user will almost never name this process, and no keyword or command is required — waiting to be asked is a failure to run it. Skip only for a genuinely trivial, contained edit (a typo, one variable rename, a single config value); when unsure, run it.

For change work rather than a new project, read "the project" below as "the change", and scope the questions to what the change should achieve instead of re-interviewing the user about a codebase that already exists.

The full rationale and a tool-agnostic writeup lives in [docs/PROTOCOL.md](docs/PROTOCOL.md) — read it if anything here is ambiguous. This file is the Codex/AGENTS.md-convention adaptation of that same protocol.

## 1. Pin the goal

Restate the deliverable in 1-2 sentences and name the real end goal — what the user will *do* with the result, not just the literal ask. Ask as many questions as it takes to resolve anything that would change the build (audience, platform, scale, stack, must-haves vs nice-to-haves, delivery constraints) — but every question must move the goal forward, never filler. Offer a recommended default with each question when you can. State anything safely inferable as a one-line assumption instead of asking.

## 2. Elect the best tool per capability

**Two capabilities are always on the plan, whatever the project is:**

1. **Session memory / continuity** — long builds outlive a context window. Without a memory layer, the goal, the agreed plan, and the reasons behind decisions vanish at the first compaction and the work drifts from what was approved. Elect the best available memory tool; recall from it *before* the step 1 questions so you don't re-ask what's already known, and persist the goal, plan, and key decisions once approved.
2. **Cost / token efficiency** — this process adds an upfront planning cost and has to earn it back. Elect the best available cost-control tool and follow it during the build: compact at phase boundaries, keep context lean, route mechanical work to cheaper models.

Elect both against what's actually available, same rules as everything else — don't assume a specific product exists. No candidate for one means it's a gap, and a missing memory layer is one of the most expensive gaps a long build can have.

Then list the capabilities the project itself needs (frontend, API, database, testing, deployment, docs, ...). For each one, find your candidate skills/tools/agents using the cheapest source first (an existing list of what's available, then a targeted search — never a brute-force read of everything installed).

- 0 candidates -> it's a gap, note it for step 4.
- 1 candidate -> use it, no comparison needed.
- 2+ candidates genuinely competing -> compare them. Read what each actually does, and where possible check external evidence (web search) for which approach is currently better regarded for this kind of project. Score on goal-fit, specificity to this stack, how much of the job it covers alone, and what the evidence favors. Pick one winner. If you can hand this comparison off to a lighter/cheaper model, do that — it's mechanical.

Never assign two tools to the same capability.

## 3. Show the plan and wait

Before building, show:

```
Goal: <1-2 sentences>
Plan:
  <capability> -> <chosen tool>  (<why, one line>)
Gaps: <list or "none">
```

Only name tools that actually exist. Wait for the user's go-ahead before building — they may want to swap something first.

## 4. Suggest what's missing

For any gap, research the best real option and suggest it with a one-line reason and where to get it. Never install without explicit approval.

## 5. Build

Only after approval, and only using the tools from the approved plan.

Activate those tools yourself — the user never types anything to trigger them. The approved plan is the authorization, so don't wait for a keyword, don't tell the user to invoke something themselves, and don't skip an elected tool and work freehand because invoking it felt like ceremony. Say which tool you're using for the current step in a few words, then use it.

The two always-on picks are easiest to forget, since no single step belongs to them. Use **memory** continuously — persist the goal, plan, and each significant decision as you go; recall before a phase whose context may have been compacted. Use the **cost** tool at phase boundaries — compact when a phase closes, carry only what the next phase needs.

If one proves a bad fit mid-build, say so and name the replacement.
