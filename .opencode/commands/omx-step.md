---
description: Execute one Windows OMX plan chunk or milestone
agent: omx
subtask: false
---
Operate in **step** mode for chunk `$ARGUMENTS`.

Current source of truth:
- @AGENTS.md
- @.omx/CONTEXT.md
- @.omx/PLAN.md
- @.omx/SESSION.log

Requirements:
- Resolve the active named plan from `.omx\PLAN.md`, then execute chunk `$ARGUMENTS`.
- Execute the whole chunk, not a single tiny edit.
- A chunk may include multiple safe local edits and local verification steps before stopping.
- Provide the exact Windows-compatible verification command for the chunk gate.
- If that command is safe, local, and non-destructive, run it yourself and include the real output.
- Only ask the user to run it when it needs manual interaction, GUI context, external credentials/systems, or a long-lived process.
- Stop only when the chunk reaches its declared gate or when `REPLAN` is needed.
- If the chunk is unclear, blocked, or oversized, return `REPLAN` instead of continuing.
