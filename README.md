# Windows OMX for OpenCode

A Windows-first, **single-agent** OMX pack for OpenCode.

This project is designed for teams that already use **OpenCode + GitHub Copilot** and want the **OMX-style user experience** — interview, sequential planning, gated execution, and explicit verification — **without subagents**.

## What this gives you

Inside an OpenCode project, this pack installs:

- `AGENTS.md` project rules
- a project-local primary OpenCode agent: `.opencode\agents\omx.md`
- project-local OpenCode commands:
  - `.opencode\commands\omx-interview.md`
  - `.opencode\commands\omx-plan.md`
  - `.opencode\commands\omx-step.md`
  - `.opencode\commands\omx-verify.md`
- OMX state files:
  - `.omx\CONTEXT.md`
  - `.omx\PLAN.md`
  - `.omx\SESSION.log`
- reusable templates and a Windows verification harness

## Recommended install model

**Best choice: project-local install**.

Why this is the best fit:
- OpenCode natively supports project-level `AGENTS.md`, `.opencode\agents\`, and `.opencode\commands\`.
- The configuration lives with the repo, so it can be shared, reviewed, and versioned by the team.
- It behaves consistently across developers and machines.
- It preserves the “this repo uses OMX protocol” signal directly in the project.

A global install is possible in theory, but it is worse for team rollout, auditing, and upgrade control.

## One-line bootstrap (copy/paste)

From **PowerShell**, run this from the checked-out pack repo to install into a target repo:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1 -TargetPath C:\path\to\your-repo
```

If you are already inside the target repo and this pack is checked out there, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1
```

## Windows installation

Run from **PowerShell**.

### Install into another repo

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1 -TargetPath C:\path\to\your-repo
```

### Install into the current repo

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1
```

### Overwrite an existing OMX pack

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1 -Force
```

## Verify the install

After installation, from the target repo root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.omx\verify-windows-protocol.ps1
```

Expected result:
- multiple `PASS: ...` lines
- a final total line like `PASS: total checks = 18`

## How to use it in OpenCode

### Mention-based flow
- `@omx interview`
- `@omx plan`
- `@omx step 1`
- `@omx verify`

### Slash-command flow
- `/omx-interview`
- `/omx-plan`
- `/omx-step 1`
- `/omx-verify`

## Phase behavior

### `@omx interview`
- asks one probing question at a time
- fills `.omx\CONTEXT.md`
- identifies Windows constraints
- refuses to plan until **Definition of Done** is explicit

### `@omx plan`
- writes a strictly sequential plan to `.omx\PLAN.md`
- uses checkbox-style / atomic steps
- requires a **Windows-compatible verify command** for each step

### `@omx step <n>`
- executes **only** the requested step
- gives only the code/change for that step
- gives the exact verify command
- refuses to continue until you paste successful output

### `@omx verify`
- compares pasted output only against the current step’s verify command
- returns only:
  - `PASS`
  - `FAIL`
  - `REPLAN`

## Windows-specific design choices

This pack is intentionally tuned for **Windows 11**:

- operator-facing paths use backslashes: `.omx\PLAN.md`
- PowerShell is the preferred automation shell
- verify commands use Windows-friendly tools such as:
  - `Test-Path`
  - `Get-Content`
  - `Select-String`
  - `npm test`
  - `dotnet test`
- interview explicitly checks:
  - PowerShell vs CMD
  - CRLF vs LF
  - important Windows paths
  - local toolchain assumptions

## What it replicates from OMX

This pack intentionally preserves the **experience** of OMX more than the internal architecture:

- strong interview gate before planning
- explicit plan gate before execution
- one-step-at-a-time execution
- verification before progress
- persistent state files
- hooks-like discipline via command contracts and hard-stop rules
- a highly opinionated system prompt / agent behavior layer

## What it does **not** replicate

Because the target environment is **GitHub Copilot without subagents**, this pack does **not** attempt to replicate:

- autonomous subagent orchestration
- background multi-lane execution
- hidden self-healing loops
- parallel reviewers arguing internally

Instead, it replaces that with:
- explicit state files
- strict command contracts
- user-pasted verification evidence
- deliberate single-agent discipline

## Docs

- Install guide: `docs\install-into-opencode-windows.md`
- Final analysis: `docs\final-analysis.md`
- Command contracts: `docs\command-response-templates.md`
- Pilot walkthrough: `docs\pilot-workflow.md`
