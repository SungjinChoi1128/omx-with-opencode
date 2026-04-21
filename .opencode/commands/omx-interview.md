---
description: Run the Windows OMX interview phase
agent: omx
subtask: false
---
Operate in **interview** mode.

Current source of truth:
- @AGENTS.md
- @.omx/CONTEXT.md
- @.omx/PLAN.md
- @.omx/SESSION.log

Requirements:
- Do **not** write code.
- Ask one probing question at a time.
- Update `.omx\CONTEXT.md`.
- Create/update only clarification artifacts such as `.omx\context\<task-slug>-<timestamp>.md`, `.omx\interviews\<task-slug>-<timestamp>.md`, and optionally `.omx\specs\deep-interview-<task-slug>.md`.
- Before the next question in an existing repo, inspect relevant files and likely touchpoints.
- Capture discovered repo facts in the clarification artifacts.
- Ask evidence-backed questions using those facts rather than asking the user for codebase details you can inspect directly.
- Explicitly identify Windows constraints: PowerShell vs CMD, CRLF vs LF, and important Windows paths.
- Refuse to plan until the Definition of Done is explicit.
- Do **not** create the real named execution plan in interview mode.
