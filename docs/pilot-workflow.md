# oh-my-opencode v1 Pilot Workflow (Windows OpenCode)

This walkthrough proves the v1 protocol can handle a happy path, a failed verification, and an interruption/resume cycle in a Windows OpenCode environment.

## Scenario
Task: add a small verified change using only `.omx\CONTEXT.md`, `.omx\PLAN.md`, `.omx\SESSION.log`, and the four `@omx` commands.

## Phase 1 — Interview
User input:
```text
@omx interview
```

Expected outcome:
- The assistant stops coding.
- The assistant asks one high-leverage clarifying question.
- The assistant confirms Windows context: PowerShell vs CMD, line endings, and important Windows paths.
- `.omx\CONTEXT.md` is updated with constraints, non-goals, definition of done, decision boundaries, and resume protocol.

## Phase 2 — Plan
User input:
```text
@omx plan
```

Expected outcome:
- `.omx\PLAN.md` is created or updated.
- Exactly one step is marked `in-progress` during active execution.
- Every step includes a Windows-compatible `verify` command such as `Test-Path`, `Get-Content`, `npm test`, or `dotnet test`.

## Phase 3 — Step execution (happy path)
User input:
```text
@omx step 1
```

Expected outcome:
- The assistant emits only step 1.
- The response ends with a validation checklist.
- The response restates the exact Windows-compatible verify requirement.

User then runs the verification command in Windows and pastes evidence.

User input:
```text
@omx verify
<pasted passing output>
```

Expected outcome:
- The assistant returns `PASS`.
- Step 1 becomes `done`.
- The next step becomes the only legal next step.

## Phase 4 — Failed verification path
User input:
```text
@omx verify
<pasted failing output>
```

Expected outcome:
- The assistant returns `FAIL`.
- The current step stays active.
- No future-step content is emitted.
- The failure evidence is appended to the append-only `.omx\SESSION.log`.
- If the pasted output is a Windows terminal error, the assistant fixes only the current step and updates `.omx\PLAN.md` if the plan must change.

## Phase 5 — Interruption and resume
At any point after a step result is recorded, the IDE or chat session may close.

Resume protocol for the next session:
1. Read `.omx\CONTEXT.md` first.
2. Read `.omx\PLAN.md` to locate the active or next legal step.
3. Read the latest timestamped entry in `.omx\SESSION.log`.
4. Continue only if doing so does not violate the hard-stop rules.

## Phase 6 — Replan trigger
If the requested work now needs more than about 5–7 active files, or if the current step is too large for one Copilot response, the assistant must return `REPLAN` and move back to planning/decomposition.

## What this pilot proves
- Resume works from files alone.
- Verification evidence is a real gate.
- The assistant does not batch future steps.
- Failed verification blocks forward progress.
- The workflow stays inside the single-agent, Windows-first, no-subagent constraint set.
