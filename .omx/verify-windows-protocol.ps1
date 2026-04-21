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
Add-Check 'context template exists' (Test-Path '.omx\templates\CONTEXT.template.md')
Add-Check 'plan template exists' (Test-Path '.omx\templates\PLAN.template.md')
Add-Check 'session template exists' (Test-Path '.omx\templates\SESSION.template.log')

$context = Get-Content '.omx\CONTEXT.md' -Raw
Add-Check 'context mentions PowerShell' ($context -match 'PowerShell')
Add-Check 'context mentions backslashes' ($context -match '\\')
Add-Check 'context requires definition of done' ($context -match 'Definition of Done')

$plan = Get-Content '.omx\PLAN.md' -Raw
Add-Check 'plan defines Windows verification guidance' (($plan -match 'Verify \(Windows\):') -or ($plan -match 'Test-Path') -or ($plan -match 'Select-String') -or ($plan -match 'powershell'))
Add-Check 'plan uses backslash paths or omx file references' (($plan -match '\.omx\\PLAN\.md') -or ($plan -match '\.omx\\CONTEXT\.md') -or ($plan -match '\.omx\\SESSION\.log'))

$commands = Get-Content 'docs\command-response-templates.md' -Raw
Add-Check 'commands mention Windows context' ($commands -match 'PowerShell vs CMD')
Add-Check 'commands require Windows verify command' ($commands -match 'Verify \(Windows\)')
Add-Check 'commands mention backslashes' ($commands -match 'Windows-style backslashes')

$pilot = Get-Content 'docs\pilot-workflow.md' -Raw
Add-Check 'pilot mentions Windows terminal error handling' ($pilot -match 'Windows terminal error')
Add-Check 'pilot uses backslash paths' ($pilot -match '\.omx\\CONTEXT\.md')

$script:checks | ForEach-Object { "{0}: {1}" -f $_.status, $_.name }
"PASS: total checks = {0}" -f $script:checks.Count
