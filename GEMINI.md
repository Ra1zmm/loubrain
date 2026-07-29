# Loubrain

Before writing any code or creating any file in response to **substantial build or change work**, run the process below:

- **New work** — build, create, start, make, scaffold, set up a project, app, site, tool, script, bot, service, feature, or MVP.
- **Changing existing work** — improve, refactor, rewrite, redesign, restructure, rearchitect, overhaul, revamp, modernize, migrate, port, or upgrade an existing project or a significant part of one.
- **Adding to existing work** — a new feature, subsystem, or module.
- **Any big change** — anything framed as major, large, from scratch, or spanning multiple files or areas.

Run it on **intent alone**. The user will almost never name this process, and no keyword or command is required. Skip only for a genuinely trivial, contained edit (a typo, one variable rename, a single config value); when unsure, run it.

For change work rather than a new project, read "the project" below as "the change", and scope the questions to what the change should achieve.

Full rationale in [docs/PROTOCOL.md](docs/PROTOCOL.md) — this file adapts that same protocol for Gemini CLI.

## 1. Pin the goal

Restate the deliverable in 1-2 sentences and name the real end goal. Ask as many focused questions as it takes to resolve anything that would change the build (audience, platform, scale, stack, must-haves, delivery constraints) — every question must move the goal forward, no filler. Offer a recommended default with each question when you can. Anything safely inferable becomes a one-line stated assumption instead of a question.

## 2. Elect the best tool per capability

List the capabilities the project needs. For each, find candidate extensions/tools/commands using the cheapest source first (what's already listed as available, then a targeted search) — never a brute-force scan of everything installed.

- 0 candidates -> gap, note for step 4.
- 1 candidate -> use it directly.
- 2+ genuinely competing -> compare what each does, check external evidence (web search) on which approach is better regarded for this kind of project, and score on goal-fit, specificity, coverage, and the evidence. Pick one winner per capability, never two.

## 3. Show the plan and wait

```
Goal: <1-2 sentences>
Plan:
  <capability> -> <chosen tool>  (<why, one line>)
Gaps: <list or "none">
```

Only name tools that actually exist. Wait for approval before building.

## 4. Suggest what's missing

For any gap, research the best real option and suggest it with a one-line reason and where to get it. Never install without explicit approval.

## 5. Build

Only after approval, only with the tools from the approved plan.

Activate those tools yourself — the user never types anything to trigger them. The approved plan is the authorization, so don't wait for a keyword, don't tell the user to invoke something themselves, and don't skip an elected tool and work freehand. Say which tool you're using for the current step, then use it.

Say so and name a replacement if one proves a bad fit mid-build.
