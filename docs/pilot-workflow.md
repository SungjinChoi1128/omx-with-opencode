# Fresh repo bootstrap
If a repo has no `.omx` and no project `AGENTS.md`, the first `@omx` invocation should auto-create the starter repo-local OMX files before normal workflow continues.

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
- The assistant inspects the existing repo before asking the next high-leverage clarifying question.
- The assistant asks one high-leverage evidence-backed clarifying question.
- The assistant confirms Windows context: PowerShell vs CMD, line endings, and important Windows paths.
- `.omx\CONTEXT.md` is updated with constraints, non-goals, definition of done, decision boundaries, and resume protocol.
- Clarification artifacts are written under `.omx\context\...` and `.omx\interviews\...`.
- The real named plan is **not** created yet.

## Phase 2 — Plan
User input:
```text
/omx-plan
```

Expected outcome:
- a named plan file is created under `.omx\plans\<task-slug>.md` and `.omx\PLAN.md` is updated as the active pointer.
- Every chunk includes a Windows-compatible `verify` command, gate type, and pass/fail conditions.
- Planning stops here and offers the next handoff options: `/omx-execute`, `/omx-step 1`, or revise the plan.

## Phase 3 — Execute approved plan
User input:
```text
/omx-execute
```

Expected outcome:
- The assistant executes one or more chunks from the active named plan.
- It continues automatically until the next real gate.
- For safe local commands, the assistant executes verification itself instead of pushing it to the user.
- If manual verification is required, it stops at that gate and asks for the required evidence.

If the verification command is safe, local, and non-destructive, the assistant should run it directly and show the real output.
If the verification requires manual interaction, GUI context, external credentials/systems, or a long-lived process, the user runs it in Windows and pastes the evidence.

User input:
```text
/omx-verify
<pasted passing output>
```

Expected outcome:
- The assistant returns `PASS`.
- The active chunk becomes `done`.
- Execution may continue automatically until the next real gate.

## Phase 4 — Failed verification path
User input:
```text
/omx-verify
<pasted failing output>
```

Expected outcome:
- The assistant returns `FAIL`.
- The current chunk stays active.
- No future-step content is emitted.
- The failure evidence is appended to the append-only `.omx\SESSION.log`.
- If the pasted output is a Windows terminal error, the assistant fixes only the current step and updates `.omx\PLAN.md` if the plan must change.

## Phase 5 — Interruption and resume
At any point after a step result is recorded, the IDE or chat session may close.

Resume protocol for the next session:
1. Read `.omx\CONTEXT.md` first.
2. Read `.omx\PLAN.md` to find the active named plan file.
3. Open that named plan file in `.omx\plans\...` to locate the active or next legal chunk.
4. Read the latest timestamped entry in `.omx\SESSION.log`.
5. Continue only if doing so does not violate the hard-stop rules.

## Phase 6 — Replan trigger
If the requested work now needs more than about 5–7 active files, or if the current step is too large for one Copilot response, the assistant must return `REPLAN` and move back to planning/decomposition.

## What this pilot proves
- Resume works from files alone.
- Verification evidence is a real gate.
- The assistant does not batch future steps.
- Failed verification blocks forward progress.
- The workflow stays inside the single-agent, Windows-first, no-subagent constraint set.
