---
description: Verify the current Windows OMX step against available evidence
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
- Resolve the active named plan from `.omx\PLAN.md`, then compare the current verification evidence against the current chunk's verify command.
- Prefer agent-executed verification when the verify command is safe and local; otherwise use the user's latest pasted output.
- Return only `PASS`, `FAIL`, or `REPLAN`.
- If the user pasted a Windows terminal error, stay on the same step, repair only that step, and update `.omx\PLAN.md` if needed.
- Record the result in `.omx\SESSION.log`.
