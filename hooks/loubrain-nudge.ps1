# UserPromptSubmit hook - nudge Claude to run the loubrain skill FIRST when the
# prompt looks like substantial build OR change work, in ANY language. No keyword
# is required: intent alone is the trigger, so the user never types /loubrain.
# Reads the hook JSON on stdin, injects additionalContext only on a match.
#
# ASCII only: Windows PowerShell 5.1 reads .ps1 as ANSI and mangles non-ASCII
# source bytes. Non-Latin scripts are therefore matched with \uXXXX regex
# escapes rather than by pasting the characters in literally.
$ErrorActionPreference = 'SilentlyContinue'

# Read stdin as UTF-8 explicitly. [Console]::In on Windows PowerShell decodes
# using the console's ANSI codepage, which corrupts every non-ASCII character
# before it can be matched - so "creer", "sozdai", CJK and Arabic prompts would
# all silently fail to trigger.
try {
  $reader = New-Object IO.StreamReader([Console]::OpenStandardInput(), [Text.Encoding]::UTF8)
  $raw = $reader.ReadToEnd()
  $reader.Dispose()
} catch { $raw = [Console]::In.ReadToEnd() }
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

try { $data = $raw | ConvertFrom-Json } catch { exit 0 }
$prompt = "$($data.prompt)"
if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

# --- English: a verb AND a scope noun must both appear ----------------------
# Requiring the noun is what keeps "rename this variable" and "create a column
# in this spreadsheet" from firing, while still catching project-level work.
$newVerb    = 'build|create|make|start|scaffold|develop|bootstrap|generate|spin\s+up|set\s+up|put\s+together|code\s+up|write\s+me|implement|\badd\b|introduce'
$changeVerb = 'improve|refactor|rewrite|re-?write|redesign|re-?design|restructure|re-?architect|rearchitect|overhaul|revamp|moderni[sz]e|migrate|port\b|upgrade|extend|expand|convert|rebuild|clean\s+up|reorganiz|reorganis'
$verb       = "$newVerb|$changeVerb"

$noun = 'project|app\b|application|web\s?app|website|web\s?site|landing\s+page|\bsite\b|tool\b|script\b|\bbot\b|\bmvp\b|dashboard|\bapi\b|backend|back[\s-]?end|front[\s-]?end|frontend|game\b|extension|plugin|saas|platform|service|micro[\s-]?service|\bcli\b|program\b|software|feature|codebase|repo\b|repository|architecture|system\b|module|component|pipeline|database|schema|infrastructure|stack\b'

# Phrases that signal a major change on their own, even without a scope noun.
$bigChange = 'from\s+scratch|ground\s+up|big\s+(change|refactor|rewrite|update)|major\s+(change|refactor|rewrite|update|overhaul)|large\s+(change|refactor)|complete\s+(rewrite|overhaul|redesign)|whole\s+thing'

# --- Other languages: the verb alone is enough ------------------------------
# A non-English prompt will not contain the English scope nouns above, so
# pairing would never match. These verbs are specific enough to stand alone.
# Accented letters are written as character classes ([e\u00e9] etc.) so both the
# accented and unaccented spellings match - users type "creer" as often as
# "creer" with the accent, and a missed accent means a missed trigger.
$latinVerb = '\b(crea|crear|creas|construye|construir|refactoriza|' +          # Spanish
             'cr[e\u00e9][e\u00e9]r|cr[e\u00e9][e\u00e9]z|construis|construire|refais|refaire|d[e\u00e9]veloppe|' + # French
             'erstelle|erstellen|baue|bauen|entwickle|' +                      # German
             'cria|criar|constr[o\u00f3][i\u00ed]|' +                          # Portuguese
             'creare|costruisci|costruire|' +                                  # Italian
             'maak|maken|bouw|' +                                              # Dutch
             'stw[o\u00f3]rz|zbuduj|' +                                        # Polish
             'olu[s\u015f]tur|olu[s\u015f]turmak|yap|yapmak|' +                # Turkish
             'buat|bikin|membuat|' +                                           # Indonesian/Malay
             'skapa|bygg|lag|lav|opret|luo|rakenna)\b'                         # Nordic/Finnish

# Non-Latin scripts, matched by codepoint so the file stays ASCII.
$cjkVerb = '[\u521b][\u5efa]|[\u505a][\u4e00][\u4e2a]|[\u5199][\u4e00][\u4e2a]|[\u91cd][\u6784]|' +   # zh: create / make one / write one / refactor
           '[\u4f5c][\u3063][\u3066]|[\u4f5c][\u6210]|[\u4f5c][\u308b]|' +                            # ja: make / create
           '[\ub9cc][\ub4e4]'                                                                          # ko: make
$cyrVerb = '[\u0441][\u043e][\u0437][\u0434]|[\u0441][\u0434][\u0435][\u043b][\u0430]|[\u043f][\u043e][\u0441][\u0442][\u0440][\u043e]'  # ru: create / make / build
$indVerb = '[\u092c][\u0928][\u093e]'                                                                  # hi: banaa (make)
$araVerb = '[\u0623][\u0646][\u0634][\u0626]|[\u0627][\u0635][\u0646][\u0639]|[\u0627][\u0628][\u0646]' # ar: create / make / build

$intlVerb = "$cjkVerb|$cyrVerb|$indVerb|$araVerb"

if ((($prompt -imatch "($verb)") -and ($prompt -imatch "($noun)")) `
    -or ($prompt -imatch "($bigChange)") `
    -or ($prompt -imatch $latinVerb) `
    -or ($prompt -imatch "($intlVerb)")) {
  $ctx = "REMINDER (global CLAUDE.md): this prompt looks like substantial build or change work, in whatever language it was written. The 'loubrain' skill is the MANDATORY first step and overrides default behavior - it fires on intent alone, so do NOT wait for the user to name it or type a slash command. Invoke it via the Skill tool BEFORE writing any code, creating any file, or invoking any other skill. Loubrain recalls prior sessions from the user's memory skill, interviews them to pin the real goal, inventories the skills and agents they already own (installed picks take priority), researches GitHub/Reddit/blogs only for genuine gaps, elects the best pick per capability when several compete, then shows ONE roster and waits for an explicit green light before installing anything or building. Present it as a single Loubrain process rather than narrating which sub-skills it uses. Once approved, invoke each elected skill yourself - the user never types a keyword. Skip loubrain only for a genuinely trivial, contained edit (a typo, one variable rename, a single config value)."
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
