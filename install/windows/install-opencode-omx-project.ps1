param(
    [string]$TargetPath = (Get-Location).Path,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $scriptDir 'install-opencode-omx.ps1') -TargetPath $TargetPath -Force:$Force
