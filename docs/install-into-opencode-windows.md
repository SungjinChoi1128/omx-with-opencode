# Install Windows OMX into OpenCode

## Recommendation
The best installation model is **project-local**, not global.

Why:
- OpenCode officially supports project-specific `AGENTS.md`, project config, and `.opencode/commands/` + `.opencode/agents/` directories.
- Project-local files are versioned with the repo and shared across the team.
- A global install would be convenient for one user, but it is harder to audit, upgrade, and keep consistent across projects.

## What this pack installs
- `AGENTS.md`
- `.opencode\agents\omx.md`
- `.opencode\commands\omx-interview.md`
- `.opencode\commands\omx-plan.md`
- `.opencode\commands\omx-step.md`
- `.opencode\commands\omx-verify.md`
- `.omx\CONTEXT.md`
- `.omx\PLAN.md`
- `.omx\SESSION.log`
- `.omx\templates\*`
- `.omx\verify-windows-protocol.ps1`
- `docs\command-response-templates.md`
- `docs\pilot-workflow.md`

## One-line bootstrap (copy/paste)

From **PowerShell**, run this from the checked-out pack repo to install into a target repo:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1 -TargetPath C:\path\to\your-repo
```

If this pack is already checked out inside the target repo, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1
```

## Install into an existing repo on Windows
From PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1 -TargetPath C:\path\to\your-repo
```

If you run it from inside the target repo, you can omit `-TargetPath`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1
```

Use `-Force` to overwrite the installed OMX pack files.

## First run inside OpenCode
Recommended flow:
- `@omx interview`
- `@omx plan`
- `@omx step 1`
- `@omx verify`

Optional slash-command equivalents:
- `/omx-interview`
- `/omx-plan`
- `/omx-step 1`
- `/omx-verify`

## Verification
After installation, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.omx\verify-windows-protocol.ps1
```

## Official OpenCode surfaces this pack uses
- Project rules via `AGENTS.md`
- Project-specific agents in `.opencode\agents\`
- Project-specific commands in `.opencode\commands\`

These are the native OpenCode extension points, so this pack installs into OpenCode without needing a separate plugin build.
