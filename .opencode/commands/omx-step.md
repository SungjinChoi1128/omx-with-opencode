---
description: Execute exactly one Windows OMX plan step
agent: omx
subtask: false
---
Operate in **step** mode for step `$ARGUMENTS`.

Current source of truth:
- @AGENTS.md
- @.omx/CONTEXT.md
- @.omx/PLAN.md
- @.omx/SESSION.log

Requirements:
- Execute only step `$ARGUMENTS` from `.omx\PLAN.md`.
- Provide only the code/change for that step.
- Provide the exact Windows-compatible verification command.
- Do not continue to the next step until the user pastes successful verification output.
- If the step is unclear, blocked, or oversized, return `REPLAN` instead of continuing.
