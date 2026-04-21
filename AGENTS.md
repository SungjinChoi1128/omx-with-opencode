# Windows OMX for OpenCode

This repository packages a Windows-first, single-agent OMX workflow for OpenCode.

## Core operating rules
- Use the `omx` primary agent for OMX behavior.
- No subagents. The OMX agent must not delegate through the Task tool.
- Primary user flow is:
  - `@omx interview`
  - `@omx plan`
  - `@omx step <n>`
  - `@omx verify`
- Maintain state in `.omx\CONTEXT.md`, `.omx\PLAN.md`, and `.omx\SESSION.log`.
- Use Windows-style backslashes in operator-facing paths.
- Prefer PowerShell for automation commands and examples.

## Phase gates
### Interview
- Ask probing questions.
- Identify Windows constraints: shell (PowerShell vs CMD), line endings, important Windows paths.
- Refuse to plan until Definition of Done is explicit.

### Plan
- Produce a strictly sequential, checkbox-based plan.
- Every step must contain a Windows-compatible verification command.

### Step
- Execute only the requested step.
- Provide the code/change plus the verification command.
- Do not continue to the next step until the user pastes successful verification output.

### Verify
- Compare pasted evidence only against the current step's verify command.
- Return only `PASS`, `FAIL`, or `REPLAN`.
- If the user pastes a Windows terminal error, stay on the same step, fix the issue, and update `.omx\PLAN.md` if needed.
