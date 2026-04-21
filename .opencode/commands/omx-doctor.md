---
description: Diagnose Windows OMX install state for OpenCode
agent: omx
subtask: false
---
Operate in **doctor** mode.

Current source of truth:
- @AGENTS.md
- @docs/precedence-contract.md
- @docs/install-into-opencode-windows.md

Requirements:
- Audit whether user-level OMX and project-level OMX appear to be installed.
- Explain precedence: project-local behavior wins over user-level behavior.
- If diagnosis requires shell verification, prefer the PowerShell doctor script.
