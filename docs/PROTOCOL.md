# The Loubrain protocol (tool-agnostic)

This is the canonical description of what Loubrain does, written without
naming any specific tool's API. Each assistant-specific file (`skills/loubrain/SKILL.md`
for Claude Code, `AGENTS.md` for Codex-family tools, `GEMINI.md` for Gemini CLI,
`.cursor/rules/loubrain.mdc` for Cursor) is an adaptation of this protocol into
that tool's native convention. If you're porting Loubrain to a new assistant,
start here.

## When it runs

Before writing any code or creating any file, on any request to build, create,
start, make, scaffold, or set up a project, app, website, tool, script, bot,
feature, or MVP — even if the user never says "kickoff" or "plan." Skip only
for a trivial one-file edit to existing code that isn't really a new project.

## Phase 1 — Understand the goal

Work out what the user is really trying to reach, not the literal request.
Restate the deliverable in 1-2 sentences, name the end goal (what the user
will *do* with the result), then ask as many questions as it takes to pin
down anything that would change the build or the toolset — audience,
platform, scale, stack preferences, must-haves vs. nice-to-haves, delivery
constraints, what "best result" means to them. Every question must move the
goal forward; nothing asked for filler. Where your tool supports offering
options, lead each question with a recommended default so the user can just
accept it. Anything safely inferable is stated as a one-line assumption
instead of asked.

## Phase 2 — Find and elect the best tools for the job

For each capability the project needs (frontend, API, database, testing,
deployment, docs, etc.), find every candidate skill/extension/agent you have
installed or available that could cover it. Use whatever low-cost mechanism
your tool offers first (a list of installed capabilities, a directory scan,
a keyword search) — never brute-force-read your entire capability library.

Per capability:
- **0 candidates** -> record as a gap (see Phase 4).
- **1 candidate** -> use it, no election needed.
- **2+ candidates competing for the same job** -> elect. Compare what each
  candidate actually does, and where you can, back the decision with
  external evidence (web search, community discussion) on which approach is
  better regarded for this kind of project. Score on: how directly it
  serves the goal, how specific it is to this stack vs. generic, how much
  of the capability it covers alone, and what the external evidence favors.
  Pick one winner per capability. If your tool can delegate this comparison
  to a cheaper/faster model, do so — it's mechanical work that doesn't need
  your full capability.

Never pick two tools for the same capability.

## Phase 3 — Show the plan, wait for approval

Present a short brief before building, and wait for the user to approve it:

```
Goal: <1-2 sentences>
Plan:
  <capability> -> <elected tool>  (<why, one line>)
  ...
Gaps: <list or "none">
```

Every tool named must actually exist in the user's setup. Don't start
building until the user gives the go-ahead — they may want to swap a pick or
drop a capability first.

## Phase 4 — Suggest what's missing

For any capability with no candidate, research what's out there (web search)
and suggest the best real option, with a one-line reason and where to get
it. Never install anything without the user's explicit OK.

## Phase 5 — Build

Only after approval. Use each capability's elected tool. If one turns out to
be a bad fit mid-build, say so and name the replacement rather than
silently dropping it.

## Cost discipline

The expensive part is Phase 2's research-backed election. Only run it when
a capability genuinely has competing candidates — most projects will have
several capabilities with a single obvious choice, which needs no research
at all. Candidate discovery itself should be a cheap scan, never a read of
every installed capability.
