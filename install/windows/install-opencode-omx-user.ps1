param(
    [string]$ConfigDir = "$env:USERPROFILE\.config\opencode",
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir '..\..')
$configRoot = [System.IO.Path]::GetFullPath($ConfigDir)

if (-not (Test-Path $configRoot)) {
    New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
}

function Copy-ManagedFile {
    param(
        [string]$Source,
        [string]$Destination
    )

    $dir = Split-Path -Parent $Destination
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    if ((Test-Path $Destination) -and (-not $Force)) {
        Write-Host "SKIP: $Destination already exists"
        return
    }

    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Host "INSTALLED: $Destination"
}

$filesToCopy = @(
    @{ Source = (Join-Path $repoRoot 'AGENTS.md'); Destination = (Join-Path $configRoot 'AGENTS.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\agents\omx.md'); Destination = (Join-Path $configRoot 'agents\omx.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-interview.md'); Destination = (Join-Path $configRoot 'commands\omx-interview.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-plan.md'); Destination = (Join-Path $configRoot 'commands\omx-plan.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-execute.md'); Destination = (Join-Path $configRoot 'commands\omx-execute.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-step.md'); Destination = (Join-Path $configRoot 'commands\omx-step.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-verify.md'); Destination = (Join-Path $configRoot 'commands\omx-verify.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-setup.md'); Destination = (Join-Path $configRoot 'commands\omx-setup.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-doctor.md'); Destination = (Join-Path $configRoot 'commands\omx-doctor.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-update.md'); Destination = (Join-Path $configRoot 'commands\omx-update.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-help.md'); Destination = (Join-Path $configRoot 'commands\omx-help.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-cancel.md'); Destination = (Join-Path $configRoot 'commands\omx-cancel.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\plugins\omx-hooks.js'); Destination = (Join-Path $configRoot 'plugins\omx-hooks.js') }
)

foreach ($file in $filesToCopy) {
    Copy-ManagedFile -Source $file.Source -Destination $file.Destination
}


$configJson = Join-Path $configRoot 'opencode.json'
$configJsonc = Join-Path $configRoot 'opencode.jsonc'
if ((-not (Test-Path $configJson)) -and (-not (Test-Path $configJsonc))) {
    Copy-Item -Path (Join-Path $repoRoot 'install\windows\opencode-user-config.fragment.jsonc') -Destination $configJson -Force
    Write-Host "INSTALLED: $configJson"
} else {
    Write-Host 'INFO: OpenCode global config already exists; leaving it unchanged.'
    Write-Host 'INFO: If you want stronger OMX parity, merge install\windows\opencode-user-config.fragment.jsonc into your existing global config.'
}
$readmePath = Join-Path $configRoot 'README-omx.txt'
if ((-not (Test-Path $readmePath)) -or $Force) {
    @'
Windows OMX user-level install is active for OpenCode.

This user-level install provides:
- global omx agent
- global omx commands
- global omx hook plugin

Project-local OMX still takes precedence inside installed repos.
Run the project installer inside a repo for repo-local state files.
'@ | Set-Content -Path $readmePath
    Write-Host "INSTALLED: $readmePath"
} else {
    Write-Host "SKIP: $readmePath already exists"
}

Write-Host ''
Write-Host 'User-level OMX install complete.'
Write-Host "Config dir: $configRoot"
Write-Host 'Next steps:'
Write-Host '1. In a new repo, run the current-repo bootstrap script or /omx-setup.'
Write-Host '2. Open OpenCode.'
Write-Host '3. Use /omx-help or @omx interview.'
