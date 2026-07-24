# UserPromptSubmit hook - nudge Claude to run the loubrain skill FIRST
# when the prompt looks like a request to build/create/start a new project.
# Reads the hook JSON on stdin, injects additionalContext only on a match.
# ASCII only: Windows PowerShell 5.1 reads .ps1 as ANSI and mangles non-ASCII.
$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

try { $data = $raw | ConvertFrom-Json } catch { exit 0 }
$prompt = "$($data.prompt)"
if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

# A build-intent verb AND a project-ish noun must both appear - cuts false positives
# on things like "create a column in this spreadsheet".
$verb = 'build|create|make|start|scaffold|develop|bootstrap|generate|spin\s+up|set\s+up|put\s+together|code\s+up|write\s+me'
$noun = 'project|app\b|application|web\s?app|website|web\s?site|landing\s+page|\bsite\b|tool\b|script\b|\bbot\b|\bmvp\b|dashboard|\bapi\b|backend|front[\s-]?end|game\b|extension|plugin|saas|platform|service|micro[\s-]?service|\bcli\b|program\b|software|feature'

if (($prompt -imatch "($verb)") -and ($prompt -imatch "($noun)")) {
  $ctx = "REMINDER (global CLAUDE.md): this prompt looks like a request to build/create/start a new project. The 'loubrain' skill is the MANDATORY first step and overrides default behavior. Invoke it via the Skill tool BEFORE writing any code, creating any file, or invoking any other skill. It extracts the user's real goal (asking as many goal-focused questions as needed, each with a recommended default), elects the single best skill AND agent per capability (a Sonnet 5 web-researched election when 2+ compete), shows the roster, suggests any missing skill to install, and waits for the user's green light before building. Skip only for a trivial edit to existing code that isn't really a new project."
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
