---
description: Verify the current Windows OMX step against pasted evidence
agent: omx
subtask: false
---
Operate in **verify** mode.

Current source of truth:
- @AGENTS.md
- @.omx/CONTEXT.md
- @.omx/PLAN.md
- @.omx/SESSION.log

Requirements:
- Compare the user's latest pasted output only against the current step's verify command in `.omx\PLAN.md`.
- Return only `PASS`, `FAIL`, or `REPLAN`.
- If the user pasted a Windows terminal error, stay on the same step, repair only that step, and update `.omx\PLAN.md` if needed.
- Record the result in `.omx\SESSION.log`.
