param(
    [string]$ConfigDir = "$env:USERPROFILE\.config\opencode"
)

$ErrorActionPreference = 'Stop'
$configRoot = [System.IO.Path]::GetFullPath($ConfigDir)

$paths = @(
    'agents\omx.md',
    'commands\omx-interview.md',
    'commands\omx-plan.md',
    'commands\omx-step.md',
    'commands\omx-verify.md',
    'commands\omx-setup.md',
    'commands\omx-doctor.md',
    'commands\omx-update.md',
    'commands\omx-help.md',
    'commands\omx-cancel.md',
    'plugins\omx-hooks.js',
    'README-omx.txt'
)

foreach ($relative in $paths) {
    $full = Join-Path $configRoot $relative
    if (Test-Path $full) {
        Remove-Item -Path $full -Force
        Write-Host "REMOVED: $full"
    } else {
        Write-Host "SKIP: $full missing"
    }
}
