param(
    [string]$ConfigDir = "$env:USERPROFILE\.config\opencode",
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$RequireProject
)

$ErrorActionPreference = 'Stop'
$configRoot = [System.IO.Path]::GetFullPath($ConfigDir)
$projectRoot = [System.IO.Path]::GetFullPath($ProjectPath)

$script:pass = 0
$script:fail = 0

function Check($Name, $Condition) {
    if ($Condition) {
        $script:pass += 1
        Write-Host "PASS: $Name"
    } else {
        $script:fail += 1
        Write-Host "FAIL: $Name"
    }
}

Check 'user config dir exists' (Test-Path $configRoot)
Check 'user omx agent exists' (Test-Path (Join-Path $configRoot 'agents\omx.md'))
Check 'user omx commands exist' ((Test-Path (Join-Path $configRoot 'commands\omx-interview.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-plan.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-execute.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-step.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-verify.md')))
Check 'user omx helper commands exist' ((Test-Path (Join-Path $configRoot 'commands\omx-setup.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-doctor.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-update.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-help.md')) -and (Test-Path (Join-Path $configRoot 'commands\omx-cancel.md')))
Check 'user omx plugin exists' (Test-Path (Join-Path $configRoot 'plugins\omx-hooks.js'))
$configJson = Join-Path $configRoot 'opencode.json'
$configJsonc = Join-Path $configRoot 'opencode.jsonc'
if ((Test-Path $configJson) -or (Test-Path $configJsonc)) {
    $cfg = if (Test-Path $configJson) { $configJson } else { $configJsonc }
    $cfgText = Get-Content $cfg -Raw
    Check 'default agent config present' ($cfgText -match 'default_agent' -and $cfgText -match 'omx')
    Check 'instructions config references AGENTS' ($cfgText -match 'instructions' -and $cfgText -match 'AGENTS\.md')
} else {
    Write-Host 'INFO: No global opencode.json/opencode.jsonc found; commands and agent still work, but default-agent/instructions parity is not enabled.'
}

$projectInstalled = (Test-Path (Join-Path $projectRoot 'AGENTS.md')) -and (Test-Path (Join-Path $projectRoot '.omx\CONTEXT.md')) -and (Test-Path (Join-Path $projectRoot '.omx\PLAN.md')) -and (Test-Path (Join-Path $projectRoot '.omx\SESSION.log'))
if ($RequireProject) {
    Check 'project AGENTS exists' (Test-Path (Join-Path $projectRoot 'AGENTS.md'))
    Check 'project .omx core exists' ((Test-Path (Join-Path $projectRoot '.omx\CONTEXT.md')) -and (Test-Path (Join-Path $projectRoot '.omx\PLAN.md')) -and (Test-Path (Join-Path $projectRoot '.omx\SESSION.log')))
    Check 'project omx plugin exists' (Test-Path (Join-Path $projectRoot '.opencode\plugins\omx-hooks.js'))
    Check 'project precedence docs exist' (Test-Path (Join-Path $projectRoot 'docs\precedence-contract.md'))
} elseif ($projectInstalled) {
    Check 'project AGENTS exists' (Test-Path (Join-Path $projectRoot 'AGENTS.md'))
    Check 'project .omx core exists' ((Test-Path (Join-Path $projectRoot '.omx\CONTEXT.md')) -and (Test-Path (Join-Path $projectRoot '.omx\PLAN.md')) -and (Test-Path (Join-Path $projectRoot '.omx\SESSION.log')))
    Check 'project omx plugin exists' (Test-Path (Join-Path $projectRoot '.opencode\plugins\omx-hooks.js'))
    Check 'project precedence docs exist' (Test-Path (Join-Path $projectRoot 'docs\precedence-contract.md'))
} else {
    Write-Host 'INFO: project-level OMX not detected; user-level install can still be valid.'
}

Write-Host ''
Write-Host "Results: $($script:pass) passed, $($script:fail) failed"
if ($script:fail -gt 0) { exit 1 }
