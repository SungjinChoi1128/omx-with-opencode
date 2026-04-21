---
description: Build the Windows OMX sequential plan
agent: omx
subtask: false
---
Operate in **plan** mode.

Current source of truth:
- @AGENTS.md
- @.omx/CONTEXT.md
- @.omx/PLAN.md
- @.omx/SESSION.log

Requirements:
- Read the latest interview/context/spec artifacts.
- Create the real named plan file in `.omx\plans\<task-slug>.md`.
- Update `.omx\PLAN.md` as the active-plan pointer.
- Create a sequential plan of meaningful chunks/milestones instead of tiny atomic approval steps.
- A chunk may include multiple safe local edits and local checks before pausing.
- Every chunk must include a Windows-compatible verification command and a gate type.
- Do not include implementation for future chunks.
- Do **not** start execution from plan mode.
- End by presenting the active plan path and the next valid actions: `/omx-execute`, `/omx-step <n>`, or revise the plan.
