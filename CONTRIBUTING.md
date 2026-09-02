# Contributing to Loubrain

Thanks for helping improve Loubrain! It's a small project, so the process is light.

## Ground rules

- **The skill is the product.** Most changes live in [`skills/loubrain/SKILL.md`](skills/loubrain/SKILL.md). Keep it under ~500 lines and explain the *why* behind instructions rather than piling on rigid `ALWAYS`/`NEVER` rules — the model follows reasoning better than commands.
- **Keep it lazy.** Loubrain's whole point is picking the *fewest, best* tools. Don't add a phase, dependency, or config knob that a one-liner or an existing mechanism already covers.
- **Cost matters.** The election runs on Sonnet and only when a capability has 2+ candidates. Any change that makes it spawn subagents more often, or read more files than a scan needs, needs a good reason.

## Making a change

1. Fork and branch (`feat/…`, `fix/…`, `docs/…`).
2. Edit the skill and/or hook.
3. If you changed behavior, add or update a prompt in [`skills/loubrain/evals/evals.json`](skills/loubrain/evals/evals.json).
4. Run the checks CI runs (see below).
5. Open a PR describing what changed and why.

## Three constraints that fail silently

Each of these has already shipped as a bug once. All are enforced in CI, but
knowing them saves a round trip.

**1. `description` must be at most 1024 characters.** Claude’s importer rejects
the whole skill otherwise, and the error only appears at upload time — every
local check passes. Trigger keywords are what make the skill fire, so compress
the mechanism explanation, never the vocabulary.

**2. Frontmatter values cannot contain an unquoted `": "`.** YAML reads a
colon-space in a plain scalar as a nested mapping, and the skill silently fails
to load. Use a sentence break or an em dash instead.

**3. The hook must stay ASCII-only, and must read stdin as UTF-8.** Windows
PowerShell 5.1 reads `.ps1` as ANSI, so non-ASCII *source* gets mangled — write
non-Latin patterns as `\uXXXX` escapes. Separately, `[Console]::In` decodes
stdin with the ANSI codepage, which corrupts non-English *prompts* before they
can match; the hook opens stdin as UTF-8 explicitly for that reason. Don’t
"simplify" either one away.

## Local checks

```bash
python -c "import json; json.load(open('skills/loubrain/evals/evals.json'))"
```

```bash
node build-skill.mjs
```

The build must be reproducible — commit the rebuilt `.skill`.

Then check the hook fires and stays quiet in the right places:

```bash
echo '{"prompt":"build me a react app"}' | pwsh -NoProfile -File hooks/loubrain-nudge.ps1
```

That should emit one line of JSON. A trivial edit ("rename the variable foo to
bar") must emit nothing, and a non-English build request ("crea una app web")
must emit JSON.

## Keeping the four descriptions in sync

The logic lives in [`docs/PROTOCOL.md`](docs/PROTOCOL.md) and is adapted into
four files: `skills/loubrain/SKILL.md` (Claude Code), `AGENTS.md` (Codex),
`GEMINI.md` (Gemini CLI), and `.cursor/rules/loubrain.mdc` (Cursor). A behavior
change belongs in all of them — CI fails if one drifts. An adapter that quietly
loses a behavior is worse than no adapter: the user believes Loubrain is running
and gets a different process.

The three non-Claude adapters must never name a Claude-specific tool
(`AskUserQuestion`, `Skill`, `ToolSearch`), since they run on hosts that have no
such thing.

## Reporting bugs / ideas

Use the [issue templates](.github/ISSUE_TEMPLATE). For triggering problems
(Loubrain fired when it shouldn't, or didn't when it should), include the exact
prompt you used — that's the most useful thing for tuning the match rules.
