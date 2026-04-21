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
- `.opencode\plugins\omx-hooks.js`
- OMX state files:
  - `.omx\CONTEXT.md`
  - `.omx\PLAN.md` (active-plan pointer)
- `.omx\plans\<task-slug>.md` (named active/history plans)
  - `.omx\SESSION.log`
- reusable templates and a Windows verification harness

## Recommended install model

Recommended deployment order:
1. Install the **user-level OMX core** once per Windows machine
2. Install the **project bootstrap** inside each repo


**Best choice: project-local install**.

Why this is the best fit:
- OpenCode natively supports project-level `AGENTS.md`, `.opencode\agents\`, and `.opencode\commands\`.
- The configuration lives with the repo, so it can be shared, reviewed, and versioned by the team.
- It behaves consistently across developers and machines.
- It preserves the “this repo uses OMX protocol” signal directly in the project.

A global install is possible in theory, but it is worse for team rollout, auditing, and upgrade control.

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

If you are already inside the target repo and this pack is checked out there, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\install-opencode-omx.ps1
```

If you need to repair an incomplete repo bootstrap, use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\bootstrap-current-repo-omx.ps1 -Force
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
- `/omx-plan`
- `/omx-execute`
- `/omx-verify`

Optional low-level override:
- `@omx step 1` (executes only the requested chunk)

### Slash-command flow
- `/omx-interview`
- `/omx-plan`
- `/omx-execute`
- `/omx-verify`

Optional low-level override:
- `/omx-step 1` (executes only the requested chunk)

## Phase behavior

### `@omx interview`
- asks one probing question at a time
- fills `.omx\CONTEXT.md` and writes clarification artifacts under `.omx\context\...` / `.omx\interviews\...`
- inspects the existing codebase before asking the next question in a brownfield repo
- uses discovered repo facts in the next question
- identifies Windows constraints
- refuses to plan until **Definition of Done** is explicit
- hands off to `/omx-plan` instead of creating the real plan itself

### `/omx-plan`
- reads the interview artifacts and creates the real named plan in `.omx\plans\<task-slug>.md`
- updates `.omx\PLAN.md` as the active pointer
- uses meaningful chunks / milestones instead of tiny approval-only steps
- requires a **Windows-compatible verify command** and a gate type for each chunk
- stops at a handoff gate and waits for `/omx-execute`, `/omx-step <n>`, or a plan revision

### `/omx-execute`
- loads the active named plan
- carries the plan forward across multiple chunks until the next real gate
- runs safe local verification automatically
- only asks you for input at manual/external/risky/replan boundaries

### `/omx-step <n>`
- is the low-level override for one specific chunk
- may perform multiple safe local edits/checks inside that chunk
- gives the exact verify command
- runs the verify command itself when it is safe, local, and non-destructive
- only asks you to run it when it needs manual interaction, external systems, GUI context, or long-lived processes
- pauses only at the requested chunk's real gate

### `/omx-verify`
- compares the current verification evidence against the active chunk’s verify command
- prefers agent-executed verification for safe local commands
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
- successful verification evidence, whether agent-run or user-provided when manual execution is required
- deliberate single-agent discipline

## Docs

- Install guide: `docs\install-into-opencode-windows.md`
- Final analysis: `docs\final-analysis.md`
- Command contracts: `docs\command-response-templates.md`
- Pilot walkthrough: `docs\pilot-workflow.md`
- Precedence contract: `docs\precedence-contract.md`
- Parity matrix: `docs\parity-matrix.md`

## Hook verification

This pack now includes a real OpenCode plugin hook at `.opencode\plugins\omx-hooks.js`.

What it does:
- logs `command.executed`, `session.created`, `session.updated`, and `session.idle` into `.omx\SESSION.log`
- blocks the `Task` tool to enforce single-agent operation
- injects Windows OMX context into compaction

Manual check inside OpenCode on Windows:
1. Start OpenCode in the installed repo
2. Run `@omx interview` or `/omx-plan`
3. Open `.omx\SESSION.log`
4. Confirm new lines beginning with `hook-event:` appear
