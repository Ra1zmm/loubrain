# Changelog

All notable changes to Loubrain are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- **Phase 0 was unrunnable as written.** It told the model to "elect" the
  session-memory capability, but electing is defined in Phase 2 and depends on
  the inventory in Phase 2a - so the very first phase required work from a
  phase two steps later. Phase 0 now does a cheap direct lookup, and the
  considered election is reserved for capabilities where the choice actually
  depends on the goal.
- **Memory was elected twice.** Phase 2 re-elected what Phase 0 had already
  picked. Phase 2 now carries the Phase 0 pick forward.
- **Phase 1 contradicted itself on batching.** It said "one question at a time"
  while pointing at a tool that takes four per call, leaving the model to guess
  - and one call per question is a round trip each, which fights the skill's
  own cost discipline. The rule is now dependency-based: dependent decisions
  one at a time, genuinely independent ones batched.
- **The roster template had lost its agent column** while Phase 2 still elected
  agents, so an elected agent had nowhere to appear.
- Phase numbering was inconsistent across three documents (SKILL.md 0-4,
  README "six phases", how-it-works "five phases" with stale 1-5 names and no
  Phase 0 at all). All now describe the same five phases, 0 through 4.
- how-it-works.md no longer names one machine's installed skills as the
  expected candidates for the always-on capabilities.

### Added
- **Phase 0 — recall before spending.** Loubrain now searches the user's
  session-memory capability before asking anything, so a project already
  scoped in an earlier session is not re-interviewed from scratch. It writes
  the goal, plan, and each decision back as it goes.
- **A real interview, not a form dump.** Phase 1 adopts the relentless
  question-at-a-time method (walk the decision tree, recommend an answer for
  each, look up facts rather than asking, don't act until there is shared
  understanding), delegating to the user's questioning skill where one exists.
- **Owned skills take priority.** Phase 2 now searches what the user already
  has *first* -- installed tools cost nothing, need no approval and are
  already trusted -- and only searches GitHub/Reddit/blogs for genuine gaps,
  judging external candidates harder as unvetted third-party code.
- **Triggers in any language.** Intent is translated before it is judged
  rather than pattern-matched against English. The hook matches build/change
  verbs across Latin, Cyrillic, CJK, Devanagari and Arabic scripts, with
  accented and unaccented spellings both covered.
- **One voice.** Loubrain presents as a single process rather than narrating
  which sub-skills it composes -- while still answering honestly if asked.
- CI gates for multilingual triggering and adapter feature parity.

### Fixed
- **The hook could never fire on a non-English prompt.** It read stdin via
  `[Console]::In`, which decodes using the console's ANSI codepage on Windows
  PowerShell and corrupts every non-ASCII character before matching. Now reads
  stdin as UTF-8 explicitly. This also broke accented Latin input ("creer"
  with an accent, "olustur" with a cedilla).
- Skills that cannot be invoked programmatically (`disable-model-invocation:
  true`) are no longer eligible for the roster -- Loubrain would have planned
  around a skill it could not actually call.

### Added
- **Downloadable `dist/loubrain.skill`** — a plain ZIP anyone can upload to
  claude.ai or Claude Code with no git and no terminal. `build-skill.mjs`
  rebuilds it with zero dependencies, and CI fails if the shipped package
  drifts from `SKILL.md` or contains backslash paths.
- Graceful handling of small or empty skill libraries: skip the election,
  keep the brief short, build with general abilities, and cap install
  suggestions at the two or three that would actually change the outcome.
- Fallbacks when an always-on capability has no candidate — write the goal
  and roster to a project file for memory, apply compaction discipline
  directly for cost — instead of stalling or inventing a winner.
- Fallback to a numbered list when `AskUserQuestion` is unavailable, and to
  internal-only scoring when web search is unavailable.

### Fixed
- **Portability: the skill assumed one specific machine.** It grepped a
  hardcoded `~/.claude/skills`, which is wrong whenever `CLAUDE_CONFIG_DIR`
  is set — and a wrong path returns no matches, which is indistinguishable
  from "this user has no candidates", so the election would quietly never
  fire. It also cited a "400+ skill" library and named the author's own
  installed skills as the expected candidates. Capabilities are now
  identified by *what a skill does*, read from its description, never by name.
- Model pinned via the durable `sonnet` alias rather than a versioned ID.
- Phase 5 reordered: the "never do this" list now sits with the rule it
  qualifies instead of being separated by two other paragraphs.
- Phase 1 scales the interview to the job, so a one-file script doesn't get
  interrogated about hosting and scale.

- **Two capabilities are now always on the roster**, regardless of the
  project: a **session-memory** skill (the `claude-mem` plugin or equivalent)
  so the goal, roster, and decisions survive a compaction, and a
  **credit/token-efficiency** skill so a long build earns back Loubrain's
  upfront planning cost. Both are elected from what is actually installed —
  nothing is hardcoded, and a missing one becomes a gap with an install
  suggestion rather than being silently skipped.
- Phase 1 now searches the elected memory skill *before* asking questions, so
  a past session's answers aren't re-requested.
- Phase 5 spells out how the two always-on picks are used, since no single
  build step "belongs" to them: memory persists decisions continuously, the
  cost skill acts at phase boundaries.
- Sixth eval covering the always-on pair, including that neither pick may be
  invented and that a missing one is reported as a gap.

### Changed
- Loubrain now triggers on **change work**, not just new projects: improving,
  refactoring, rewriting, redesigning, restructuring, migrating, modernizing,
  or extending an existing project, adding a non-trivial feature, or any
  change framed as big/major/from-scratch.
- Made explicit that Loubrain fires on **intent alone** — no keyword, no
  `/loubrain`, no confirmation. Waiting to be named is a failure to run.
- Phase 5 now states that elected skills are invoked directly by the
  assistant once the roster is approved. The user never types a keyword or
  slash command to activate them; the approved roster is the authorization.
- The trigger hook matches change verbs and scope nouns, plus standalone
  big-change phrases ("from scratch", "major refactor"). Trivial edits
  ("rename this variable", "fix the typo") still correctly stay silent.
- Same changes carried into docs/PROTOCOL.md and all three cross-tool
  adapters so behavior is consistent across assistants.
- README and docs/how-it-works.md rewritten to match: new "When it fires"
  table (fires vs. stays out of the way), no-keyword usage section, updated
  `CLAUDE.md` block, and a description of how the trigger hook matches.
- Eval set extended from 2 to 5 cases, covering a refactor, a feature
  addition, and a trivial rename that must *not* trigger a kickoff.
- CI now checks 16 trigger cases (10 fire, 6 stay silent) instead of 2, and
  asserts the hook exits 0 on malformed input.

### Fixed
- Installers now honor `CLAUDE_CONFIG_DIR` instead of assuming `~/.claude`.
  Previously, users with a relocated Claude config got a stray directory in
  their home folder that Claude Code never loads, so Loubrain appeared to
  install successfully while doing nothing.
- Installers no longer nest a duplicate `skills/loubrain/loubrain/` on
  re-run (`cp -R` / `Copy-Item -Recurse` copy *into* an existing target).
  The previous copy is now removed first, which also clears stale files
  left over from an older version.

### Added
- `docs/PROTOCOL.md` — tool-agnostic canonical description of the five-phase
  process, source of truth for all assistant adapters.
- `AGENTS.md` — adapter for Codex CLI and other `AGENTS.md`-convention tools.
- `GEMINI.md` — adapter for Gemini CLI.
- `.cursor/rules/loubrain.mdc` — adapter for Cursor.
- CI checks that the adapters exist and stay free of Claude-Code-specific
  tool names.
- README "Compatibility" section and per-tool install instructions.

## [0.1.0] - 2026-07-24

### Added
- Initial release of the **Loubrain** skill (`skills/loubrain/SKILL.md`).
- Five-phase kickoff flow: goal extraction, skill/agent election, roster,
  gap suggestions, gated build.
- Cost-aware election that runs on a Claude Sonnet subagent and only fires
  when 2+ candidates compete for a capability.
- Web + Reddit/blog-backed scoring for contested capabilities.
- Election of agents as well as skills.
- Goal questions carry a recommended default option.
- "Always-first" enforcement via a global `CLAUDE.md` rule and a
  `UserPromptSubmit` hook (`hooks/loubrain-nudge.ps1`).
- Windows and POSIX installers.
- Eval prompts and assertions under `skills/loubrain/evals/`.
