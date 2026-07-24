# Changelog

All notable changes to Loubrain are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/spec/v2.0.0.html).

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
