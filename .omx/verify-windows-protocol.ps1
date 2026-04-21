$ErrorActionPreference = 'Stop'

$script:checks = @()

function Add-Check($Name, $Passed) {
    $status = if ($Passed) { 'PASS' } else { 'FAIL' }
    $script:checks += [pscustomobject]@{ name = $Name; status = $status }
    if (-not $Passed) { throw "Check failed: $Name" }
}

Add-Check 'context exists' (Test-Path '.omx\CONTEXT.md')
Add-Check 'plan exists' (Test-Path '.omx\PLAN.md')
Add-Check 'session exists' (Test-Path '.omx\SESSION.log')
Add-Check 'commands doc exists' (Test-Path 'docs\command-response-templates.md')
Add-Check 'pilot doc exists' (Test-Path 'docs\pilot-workflow.md')
Add-Check 'project precedence doc exists' (Test-Path 'docs\precedence-contract.md')
Add-Check 'project parity matrix exists' (Test-Path 'docs\parity-matrix.md')
Add-Check 'user config fragment exists' (Test-Path 'install\windows\opencode-user-config.fragment.jsonc')
Add-Check 'bootstrap current repo script exists' (Test-Path 'install\windows\bootstrap-current-repo-omx.ps1')
Add-Check 'active plan template exists' (Test-Path '.omx\templates\ACTIVE_PLAN.template.md')
Add-Check 'context template exists' (Test-Path '.omx\templates\CONTEXT.template.md')
Add-Check 'plan template exists' (Test-Path '.omx\templates\PLAN.template.md')
Add-Check 'session template exists' (Test-Path '.omx\templates\SESSION.template.log')
Add-Check 'setup command exists' (Test-Path '.opencode\commands\omx-setup.md')
Add-Check 'doctor command exists' (Test-Path '.opencode\commands\omx-doctor.md')
Add-Check 'execute command exists' (Test-Path '.opencode\commands\omx-execute.md')
Add-Check 'update command exists' (Test-Path '.opencode\commands\omx-update.md')
Add-Check 'help command exists' (Test-Path '.opencode\commands\omx-help.md')
Add-Check 'cancel command exists' (Test-Path '.opencode\commands\omx-cancel.md')
Add-Check 'hook plugin exists' (Test-Path '.opencode\plugins\omx-hooks.js')

$context = Get-Content '.omx\CONTEXT.md' -Raw
Add-Check 'context mentions PowerShell' ($context -match 'PowerShell')
Add-Check 'context mentions backslashes' ($context -match '\\')
Add-Check 'context requires definition of done' ($context -match 'Definition of Done')

$plan = Get-Content '.omx\PLAN.md' -Raw
Add-Check 'plan defines Windows verification guidance' (($plan -match 'Verify \(Windows\):') -or ($plan -match 'Test-Path') -or ($plan -match 'Select-String') -or ($plan -match 'powershell'))
Add-Check 'plan uses backslash paths or omx file references' (($plan -match '\.omx\\PLAN\.md') -or ($plan -match '\.omx\\CONTEXT\.md') -or ($plan -match '\.omx\\SESSION\.log'))

$plugin = Get-Content '.opencode\plugins\omx-hooks.js' -Raw
$commands = Get-Content 'docs\command-response-templates.md' -Raw
Add-Check 'commands mention Windows context' ($commands -match 'PowerShell vs CMD')
Add-Check 'commands require Windows verify command' ($commands -match 'Verify \(Windows\)')
Add-Check 'commands document execute mode' ($commands -match '@omx execute')
Add-Check 'interview docs require repo grounding' ($commands -match 'inspect relevant files' -and $commands -match 'Repo facts found')
Add-Check 'plan docs enforce handoff gate' ($commands -match 'Do \*\*not\*\* start execution from plan mode' -or $commands -match 'handoff')
Add-Check 'commands mention backslashes' ($commands -match 'Windows-style backslashes')
Add-Check 'project docs mention user-level install' ((Get-Content 'README.md' -Raw) -match 'install-opencode-omx-user.ps1')
Add-Check 'project docs mention bootstrap current repo' ((Get-Content 'README.md' -Raw) -match 'bootstrap-current-repo-omx.ps1')
Add-Check 'auto-bootstrap docs present' ((Get-Content 'README.md' -Raw) -match 'auto-create the starter repo-local files')
Add-Check 'repair-flow docs present' ((Get-Content 'README.md' -Raw) -match 'repair an incomplete repo bootstrap')
Add-Check 'hook plugin logs command events' ($plugin -match 'command.executed')
Add-Check 'hook plugin blocks Task tool' ($plugin -match 'Task tool' -or $plugin -match 'Task/subagents')
Add-Check 'hook plugin supports compaction context' ($plugin -match 'experimental.session.compacting')
Add-Check 'hook bootstrap logic present' ($plugin -match 'ensureRepoBootstrap' -and $plugin -match 'Created starter OMX files')

$pilot = Get-Content 'docs\pilot-workflow.md' -Raw
Add-Check 'pilot mentions Windows terminal error handling' ($pilot -match 'Windows terminal error')
Add-Check 'pilot uses backslash paths' ($pilot -match '\.omx\\CONTEXT\.md')

$script:checks | ForEach-Object { "{0}: {1}" -f $_.status, $_.name }
"PASS: total checks = {0}" -f $script:checks.Count
