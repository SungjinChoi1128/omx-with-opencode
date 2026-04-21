---
description: Execute the active named OMX plan end-to-end until the next real gate
agent: omx
subtask: false
---
Operate in **execute** mode.

Current source of truth:
- @AGENTS.md
- @.omx/CONTEXT.md
- @.omx/PLAN.md
- @.omx/SESSION.log

Requirements:
- Resolve the active named plan from `.omx\PLAN.md`.
- Continue executing chunks from that plan until you hit a real gate:
  - manual verification
  - GUI/manual interaction
  - external credentials/systems
  - risky or destructive action
  - replan boundary
- Within a chunk, complete multiple safe local edits and safe local verification steps without asking for approval after every tiny step.
- Run safe local verification commands yourself.
- Only ask the user to run verification when it truly requires manual or external execution.
- Update `.omx\PLAN.md` pointer metadata and `.omx\SESSION.log` as progress advances.
- If no active named plan exists, stop and direct the user to `/omx-plan`.
