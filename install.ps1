# Loubrain installer (Windows / PowerShell)
# Copies the skill + hook into ~/.claude and wires the CLAUDE.md rule and the
# UserPromptSubmit hook. Idempotent and non-destructive: existing config is
# backed up before any edit, and nothing is duplicated on a re-run.
# ASCII-only on purpose (Windows PowerShell 5.1 mangles non-ASCII in .ps1).

$ErrorActionPreference = 'Stop'
$repo  = Split-Path -Parent $MyInvocation.MyCommand.Path
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

# Claude Code reads its config from CLAUDE_CONFIG_DIR when that is set, and
# only falls back to ~/.claude otherwise. Installing to the wrong one leaves a
# stray directory that Claude never loads, so honor the env var first.
if ($env:CLAUDE_CONFIG_DIR) { $claude = $env:CLAUDE_CONFIG_DIR }
else                        { $claude = Join-Path $HOME '.claude' }

function Say($m) { Write-Host "[loubrain] $m" }
Say "Config directory: $claude"

# --- 1. Copy skill + hook -------------------------------------------------
New-Item -ItemType Directory -Force -Path (Join-Path $claude 'skills') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $claude 'loubrain-hooks') | Out-Null

# Remove any previous copy first: Copy-Item -Recurse into an existing directory
# nests a duplicate inside it, and a stale file from an older version would
# otherwise survive the upgrade.
$skillDest = Join-Path $claude 'skills\loubrain'
if (Test-Path $skillDest) { Remove-Item -Recurse -Force $skillDest }
Copy-Item -Recurse -Force (Join-Path $repo 'skills\loubrain') $skillDest
Copy-Item -Force (Join-Path $repo 'hooks\loubrain-nudge.ps1') (Join-Path $claude 'loubrain-hooks\loubrain-nudge.ps1')
Say 'Copied skill -> ~/.claude/skills/loubrain'
Say 'Copied hook  -> ~/.claude/loubrain-hooks/loubrain-nudge.ps1'

# --- 2. CLAUDE.md rule ----------------------------------------------------
$cmd = Join-Path $claude 'CLAUDE.md'
$rule = @'
# loubrain - SUPERIOR SKILL, ALWAYS FIRST
IMPORTANT: **loubrain** (`~/.claude/skills/loubrain/SKILL.md`) is the master, top-priority skill. It OVERRIDES default behavior and takes precedence over every other skill for any substantial build or change work: building, creating, starting, scaffolding, or setting up a project, app, website, tool, script, or bot, AND improving, refactoring, rewriting, redesigning, restructuring, migrating, modernizing, or extending an existing project, plus adding any non-trivial feature or making any big change.
- It is the FIRST thing to run on any such request - before writing a single line of code or creating any file, and before invoking any other skill.
- It fires on INTENT ALONE. No keyword, no `/loubrain`, no confirmation needed - the user will almost never name it, and waiting to be asked is a failure to run it.
- Once loubrain's roster is approved, invoke each elected skill yourself with the Skill tool. The user never types a keyword or slash command to activate them; the approved roster is the authorization.
- Only exception: a genuinely trivial, contained edit (a typo, one variable rename, a single config value). When unsure whether a change is trivial or substantial, run loubrain.

'@
if ((Test-Path $cmd) -and (Select-String -Path $cmd -Pattern 'loubrain' -Quiet)) {
  Say 'CLAUDE.md already mentions loubrain - left as is.'
} else {
  if (Test-Path $cmd) {
    Copy-Item $cmd "$cmd.bak-$stamp"
    $rule + (Get-Content $cmd -Raw) | Set-Content -Path $cmd -Encoding UTF8
  } else {
    $rule | Set-Content -Path $cmd -Encoding UTF8
  }
  Say 'Added loubrain rule to ~/.claude/CLAUDE.md'
}

# --- 3. settings.json UserPromptSubmit hook -------------------------------
$sf  = Join-Path $claude 'settings.json'
$hookCmd = 'powershell -NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $claude 'loubrain-hooks\loubrain-nudge.ps1') + '"'

# Recursively turn a ConvertFrom-Json PSCustomObject into nested hashtables/arrays
# so we can safely mutate and re-serialize (PS 5.1 has no -AsHashtable).
function ConvertTo-HashtableDeep($o) {
  if ($null -eq $o) { return $null }
  if ($o -is [System.Collections.IEnumerable] -and $o -isnot [string]) {
    return @($o | ForEach-Object { ConvertTo-HashtableDeep $_ })
  }
  if ($o -is [psobject] -and $o.PSObject.Properties.Count -gt 0 -and $o.GetType().Name -eq 'PSCustomObject') {
    $h = @{}
    foreach ($p in $o.PSObject.Properties) { $h[$p.Name] = ConvertTo-HashtableDeep $p.Value }
    return $h
  }
  return $o
}

if ((Test-Path $sf) -and (Select-String -Path $sf -Pattern 'loubrain-nudge' -Quiet)) {
  Say 'settings.json already wires the loubrain hook - left as is.'
} else {
  if (Test-Path $sf) {
    Copy-Item $sf "$sf.bak-$stamp"
    $s = ConvertTo-HashtableDeep ((Get-Content $sf -Raw) | ConvertFrom-Json)
  } else {
    $s = @{}
  }
  if (-not $s.ContainsKey('hooks'))                 { $s['hooks'] = @{} }
  if (-not $s['hooks'].ContainsKey('UserPromptSubmit')) { $s['hooks']['UserPromptSubmit'] = @() }

  $entry = @{ type = 'command'; command = $hookCmd; timeout = 10; statusMessage = 'Loubrain: checking for new-project intent...' }

  $ups = @($s['hooks']['UserPromptSubmit'])
  if ($ups.Count -ge 1 -and $ups[0].ContainsKey('hooks')) {
    $ups[0]['hooks'] = @($ups[0]['hooks']) + $entry
  } else {
    $ups = $ups + @{ hooks = @($entry) }
  }
  $s['hooks']['UserPromptSubmit'] = $ups

  ($s | ConvertTo-Json -Depth 20) | Set-Content -Path $sf -Encoding UTF8
  Say 'Wired loubrain hook into ~/.claude/settings.json'
}

Say 'Done. Restart Claude Code (or open /hooks once) so the hook loads.'
