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

## Local checks

```bash
# SKILL.md has valid YAML frontmatter with name + description
# evals.json is valid JSON
python -c "import json,sys; json.load(open('skills/loubrain/evals/evals.json'))"
```

The PowerShell hook must stay **ASCII-only** — Windows PowerShell 5.1 reads `.ps1`
as ANSI and mangles smart quotes / em dashes, which breaks parsing. Test it:

```bash
echo '{"prompt":"build me a react app"}' | pwsh -NoProfile -File hooks/loubrain-nudge.ps1
```

It should emit one line of JSON. A non-build prompt should emit nothing.

## Reporting bugs / ideas

Use the [issue templates](.github/ISSUE_TEMPLATE). For triggering problems
(Loubrain fired when it shouldn't, or didn't when it should), include the exact
prompt you used — that's the most useful thing for tuning the match rules.
