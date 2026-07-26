# Loubrain

You have access to a broader set of capabilities than most single requests need — installed skills, extensions, MCP tools, or sub-agents. Before you write any code or create any file in response to a request to build, create, start, make, scaffold, or set up a project, app, website, tool, script, bot, feature, or MVP, run the process below. Skip it only for a trivial one-file edit to existing code that isn't really a new project.

The full rationale and a tool-agnostic writeup lives in [docs/PROTOCOL.md](docs/PROTOCOL.md) — read it if anything here is ambiguous. This file is the Codex/AGENTS.md-convention adaptation of that same protocol.

## 1. Pin the goal

Restate the deliverable in 1-2 sentences and name the real end goal — what the user will *do* with the result, not just the literal ask. Ask as many questions as it takes to resolve anything that would change the build (audience, platform, scale, stack, must-haves vs nice-to-haves, delivery constraints) — but every question must move the goal forward, never filler. Offer a recommended default with each question when you can. State anything safely inferable as a one-line assumption instead of asking.

## 2. Elect the best tool per capability

List the capabilities the project needs (frontend, API, database, testing, deployment, docs, ...). For each one, find your candidate skills/tools/agents using the cheapest source first (an existing list of what's available, then a targeted search — never a brute-force read of everything installed).

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

Only after approval, and only using the tools from the approved plan. If one proves a bad fit mid-build, say so and name the replacement.
