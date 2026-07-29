# UserPromptSubmit hook - nudge Claude to run the loubrain skill FIRST when the
# prompt looks like substantial build OR change work. No keyword is required:
# intent alone is the trigger, so the user never types /loubrain.
# Reads the hook JSON on stdin, injects additionalContext only on a match.
# ASCII only: Windows PowerShell 5.1 reads .ps1 as ANSI and mangles non-ASCII.
$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

try { $data = $raw | ConvertFrom-Json } catch { exit 0 }
$prompt = "$($data.prompt)"
if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

# Match strategy: a verb AND a scope noun must both appear. Requiring the noun
# is what keeps "rename this variable" or "create a column in this spreadsheet"
# from firing, while still catching project-level work.
#
# Verbs come in two families:
#   $newVerb    - starting something that does not exist yet
#   $changeVerb - reworking something that already does (the big-change case)
$newVerb    = 'build|create|make|start|scaffold|develop|bootstrap|generate|spin\s+up|set\s+up|put\s+together|code\s+up|write\s+me|implement|\badd\b|introduce'
$changeVerb = 'improve|refactor|rewrite|re-?write|redesign|re-?design|restructure|re-?architect|rearchitect|overhaul|revamp|moderni[sz]e|migrate|port\b|upgrade|extend|expand|convert|rebuild|clean\s+up|reorganiz|reorganis'
$verb       = "$newVerb|$changeVerb"

$noun = 'project|app\b|application|web\s?app|website|web\s?site|landing\s+page|\bsite\b|tool\b|script\b|\bbot\b|\bmvp\b|dashboard|\bapi\b|backend|back[\s-]?end|front[\s-]?end|frontend|game\b|extension|plugin|saas|platform|service|micro[\s-]?service|\bcli\b|program\b|software|feature|codebase|repo\b|repository|architecture|system\b|module|component|pipeline|database|schema|infrastructure|stack\b'

# Phrases that signal a major change on their own, even without a scope noun -
# e.g. "rewrite this from scratch", "this needs a major refactor".
$bigChange = 'from\s+scratch|ground\s+up|big\s+(change|refactor|rewrite|update)|major\s+(change|refactor|rewrite|update|overhaul)|large\s+(change|refactor)|complete\s+(rewrite|overhaul|redesign)|whole\s+thing'

if ((($prompt -imatch "($verb)") -and ($prompt -imatch "($noun)")) -or ($prompt -imatch "($bigChange)")) {
  $ctx = "REMINDER (global CLAUDE.md): this prompt looks like substantial build or change work. The 'loubrain' skill is the MANDATORY first step and overrides default behavior - it fires on intent alone, so do NOT wait for the user to name it or type a slash command. Invoke it via the Skill tool BEFORE writing any code, creating any file, or invoking any other skill. It extracts the user's real goal (asking as many goal-focused questions as needed, each with a recommended default), elects the single best skill AND agent per capability (a Sonnet 5 web-researched election when 2+ compete), shows the roster, and waits for the user's green light. Once the roster is approved, invoke each elected skill yourself with the Skill tool - the user never types a keyword to activate them. Skip loubrain only for a genuinely trivial, contained edit (a typo, one variable rename, a single config value)."
  $out = @{
    hookSpecificOutput = @{
      hookEventName     = 'UserPromptSubmit'
      additionalContext = $ctx
    }
    suppressOutput = $true
  } | ConvertTo-Json -Compress -Depth 5
  Write-Output $out
}
exit 0
