---
description: End the current OMX workflow cleanly
agent: omx
subtask: false
---
Operate in **cancel** mode.

Current source of truth:
- @AGENTS.md
- @.omx/SESSION.log

Requirements:
- Stop the current OMX workflow cleanly.
- Summarize the last known state.
- If `.omx\SESSION.log` exists, instruct the operator to leave a final note there if needed.
