# Changelog

All notable changes to Loubrain are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
