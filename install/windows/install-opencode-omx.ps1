param(
    [string]$TargetPath = (Get-Location).Path,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir '..\..')
$target = [System.IO.Path]::GetFullPath($TargetPath)
if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
}

function Copy-TextFile {
    param(
        [string]$Source,
        [string]$Destination
    )

    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    if ((Test-Path $Destination) -and (-not $Force)) {
        Write-Host "SKIP: $Destination already exists"
        return
    }

    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Host "INSTALLED: $Destination"
}

$filesToCopy = @(
    @{ Source = (Join-Path $repoRoot 'AGENTS.md'); Destination = (Join-Path $target 'AGENTS.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\agents\omx.md'); Destination = (Join-Path $target '.opencode\agents\omx.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-interview.md'); Destination = (Join-Path $target '.opencode\commands\omx-interview.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-plan.md'); Destination = (Join-Path $target '.opencode\commands\omx-plan.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-step.md'); Destination = (Join-Path $target '.opencode\commands\omx-step.md') },
    @{ Source = (Join-Path $repoRoot '.opencode\commands\omx-verify.md'); Destination = (Join-Path $target '.opencode\commands\omx-verify.md') },
    @{ Source = (Join-Path $repoRoot '.omx\templates\CONTEXT.template.md'); Destination = (Join-Path $target '.omx\templates\CONTEXT.template.md') },
    @{ Source = (Join-Path $repoRoot '.omx\templates\PLAN.template.md'); Destination = (Join-Path $target '.omx\templates\PLAN.template.md') },
    @{ Source = (Join-Path $repoRoot '.omx\templates\SESSION.template.log'); Destination = (Join-Path $target '.omx\templates\SESSION.template.log') },
    @{ Source = (Join-Path $repoRoot '.omx\verify-windows-protocol.ps1'); Destination = (Join-Path $target '.omx\verify-windows-protocol.ps1') },
    @{ Source = (Join-Path $repoRoot 'docs\command-response-templates.md'); Destination = (Join-Path $target 'docs\command-response-templates.md') },
    @{ Source = (Join-Path $repoRoot 'docs\pilot-workflow.md'); Destination = (Join-Path $target 'docs\pilot-workflow.md') }
)

foreach ($file in $filesToCopy) {
    Copy-TextFile -Source $file.Source -Destination $file.Destination
}

$contextTarget = Join-Path $target '.omx\CONTEXT.md'
$planTarget = Join-Path $target '.omx\PLAN.md'
$sessionTarget = Join-Path $target '.omx\SESSION.log'

if ((-not (Test-Path $contextTarget)) -or $Force) {
    @'
# Project Context

## Objective
<fill during @omx interview>

## Why this exists
<fill during @omx interview>

## Windows execution context
- Preferred shell: PowerShell
- Line endings: CRLF or LF (confirm during interview)
- Workspace root: C:\path\to\repo (confirm during interview)
- Tooling notes: <npm|dotnet|python|other>

## Constraints
- <fill during @omx interview>

## Non-goals
- <fill during @omx interview>

## Definition of Done
- <must be explicit before @omx plan>

## Path conventions
- Use Windows-style backslashes like `src\Program.cs` and `.omx\PLAN.md`.

## Decision boundaries
- <fill during @omx interview>
'@ | Set-Content -Path $contextTarget
    Write-Host "INSTALLED: $contextTarget"
}
else {
    Write-Host "SKIP: $contextTarget already exists"
}

if ((-not (Test-Path $planTarget)) -or $Force) {
    @'
# Project Plan

## Rules
- One active step at a time
- Every step needs a Windows-compatible verification command
- No step n+1 before step n verifies

## Steps
- [ ] Step 1: Create plan during @omx plan
  Verify (Windows): <fill during @omx plan>
'@ | Set-Content -Path $planTarget
    Write-Host "INSTALLED: $planTarget"
}
else {
    Write-Host "SKIP: $planTarget already exists"
}

if ((-not (Test-Path $sessionTarget)) -or $Force) {
    "[${(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')}] decision-note: Windows OMX pack installed." | Set-Content -Path $sessionTarget
    Write-Host "INSTALLED: $sessionTarget"
}
else {
    Write-Host "SKIP: $sessionTarget already exists"
}

Write-Host ''
Write-Host 'Next steps:'
Write-Host '1. Open your target repo in OpenCode.'
Write-Host '2. Use @omx interview to begin.'
Write-Host '3. Optionally verify the pack with powershell -ExecutionPolicy Bypass -File .\.omx\verify-windows-protocol.ps1'
