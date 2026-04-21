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
- `.opencode\plugins\omx-hooks.js`
- `.omx\CONTEXT.md`
- `.omx\PLAN.md` (active-plan pointer)
- `.omx\plans\<task-slug>.md` (named active/history plans)
- `.omx\SESSION.log`
- `.omx\templates\*`
- `.omx\verify-windows-protocol.ps1`
- `docs\command-response-templates.md`
- `docs\pilot-workflow.md`

## User-level install (Windows machine)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx-user.ps1
```

The user installer also seeds a global `opencode.json` with `default_agent: "omx"` and `instructions: ["AGENTS.md"]` **only if no global config exists yet**. If you already have `opencode.json` or `opencode.jsonc`, it will be left unchanged and you can merge `install\windows\opencode-user-config.fragment.jsonc` manually.

Optional maintenance commands:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\doctor-opencode-omx-user.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\update-opencode-omx-user.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\uninstall-opencode-omx-user.ps1
```

## Project bootstrap (copy/paste)

Recommended easiest path inside a new repo:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\bootstrap-current-repo-omx.ps1
```

If you type `@omx` in a repo that is missing the required local OMX files, the **hook plugin now creates the starter repo-local files mechanically** before normal workflow continues.
If a repo has partial OMX state, the hook fills in the missing starter files without overwriting existing ones.


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
- `/omx-plan`
- `/omx-execute`
- `/omx-verify`

Optional low-level override:
- `@omx step 1` (runs only the requested chunk)

Expected behavior:
- interview creates clarification artifacts only
- interview inspects the current codebase before asking the next question in an existing repo
- plan creates the real named plan
- plan stops at an explicit handoff gate
- execute carries the active plan forward until the next real gate
- for safe local verify commands, OMX should run them itself
- it should ask you to run verification only for manual/GUI/external/long-lived checks
- ``/omx-verify` is mainly for judging manual or already-captured verification evidence

If you need to repair an incomplete repo bootstrap, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\bootstrap-current-repo-omx.ps1 -Force
```

Optional slash-command equivalents:
- `/omx-interview`
- `/omx-plan`
- `/omx-execute`
- `/omx-step 1` (runs only the requested chunk)
- `/omx-verify`
- `/omx-setup` (bootstraps the current repo when local OMX is missing)
- `/omx-doctor`
- `/omx-update`
- `/omx-help`
- `/omx-cancel`

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

## Hook validation

This pack installs a real OpenCode plugin hook at `.opencode\plugins\omx-hooks.js`.

To confirm hooks are firing inside OpenCode on Windows:

1. Open the installed repo in OpenCode
2. Run one OMX action such as `@omx interview` or `/omx-plan`
3. Open `.omx\SESSION.log`
4. Confirm entries like these were appended:
   - `hook-event: session.created`
   - `hook-event: command.executed -> ...`

If those entries appear, the OpenCode hook plugin is loaded and firing.
