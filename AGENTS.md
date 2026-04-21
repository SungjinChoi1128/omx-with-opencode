# Windows OMX for OpenCode

This repository packages a Windows-first, single-agent OMX workflow for OpenCode.

## Core operating rules
- Use the `omx` primary agent for OMX behavior.
- No subagents. The OMX agent must not delegate through the Task tool.
- Primary user flow is:
  - `@omx interview`
  - `/omx-plan`
  - `/omx-execute`
  - `/omx-verify`
- Optional low-level override: `/omx-step <n>` for targeted chunk execution.
- Maintain state in `.omx\CONTEXT.md`, `.omx\PLAN.md`, and `.omx\SESSION.log`.
- Use Windows-style backslashes in operator-facing paths.
- Prefer PowerShell for automation commands and examples.

## Phase gates
### Interview
- Ask probing questions.
- Before the next question in an existing repo, inspect relevant codebase files and likely touchpoints first.
- Identify Windows constraints: shell (PowerShell vs CMD), line endings, important Windows paths.
- Refuse to plan until Definition of Done is explicit.
- Ask evidence-backed questions that reference discovered codebase facts instead of asking the user for repo facts the agent can inspect itself.
- Create or update clarification artifacts only: `.omx\CONTEXT.md`, `.omx\context\<task-slug>-<timestamp>.md`, `.omx\interviews\<task-slug>-<timestamp>.md`, and optionally `.omx\specs\deep-interview-<task-slug>.md`.
- Do **not** create the real named execution plan during interview. The handoff from interview is `/omx-plan`.

### Plan
- Create the real **named plan file** under `.omx\plans\<task-slug>.md`.
- Update `.omx\PLAN.md` as the **active-plan pointer** to that named plan.
- Produce a sequential plan made of **meaningful chunks or milestones**, not tiny approval-only microsteps.
- Every chunk must contain a Windows-compatible verification command and a gate type.
- Planning is the only phase that creates or replaces the active named execution plan.

### Execute
- Continue the active named plan end-to-end until the next real gate.
- A chunk may include multiple safe local edits and local verification steps.
- Run safe local verification yourself.
- Stop only at a real gate: manual verify, external dependency, risky action, or replan boundary.

### Step
- `/omx-step <n>` is the low-level override for a specific chunk.
- Execute the requested **chunk** from the active named plan.
- A chunk may include multiple safe local edits and local verification steps.
- If the verification command is safe, local, and non-destructive, run it yourself and report the actual output.
- Only ask the user to run verification when it requires manual interaction, external credentials/systems, GUI context, or a long-lived process.
- Stop only at the requested chunk's real gate.

### Verify
- Compare the available verification evidence against the active chunk's verify command.
- Prefer agent-executed verification when the command is safe and local; otherwise compare the user's pasted evidence.
- Return only `PASS`, `FAIL`, or `REPLAN`.
- If the user pastes a Windows terminal error, stay on the same chunk, fix the issue, and update the named plan / `.omx\PLAN.md` pointer if needed.
