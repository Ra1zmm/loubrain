# Loubrain

Before writing any code or creating any file in response to a request to build, create, start, make, scaffold, or set up a project, app, website, tool, script, bot, feature, or MVP, run the process below. Skip it only for a trivial one-file edit to existing code that isn't really a new project.

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

Only after approval, only with the tools from the approved plan. Say so and name a replacement if one proves a bad fit mid-build.
