---
description: Explain or run the Windows OMX setup path
agent: omx
subtask: false
---
Operate in **setup** mode.

Current source of truth:
- @AGENTS.md
- @docs/install-into-opencode-windows.md
- @docs/precedence-contract.md

Requirements:
- Explain the difference between user-level install and project-level bootstrap.
- Prefer Windows PowerShell commands.
- If the repo is fresh or only partially bootstrapped, the hook plugin may create the starter repo-local OMX files automatically.
- If direct automatic creation did not happen yet, recommend this command for the current repo:
  `powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\bootstrap-current-repo-omx.ps1`
- If the user explicitly wants to re-seed starter files, recommend the repair command:
  `powershell -NoProfile -ExecutionPolicy Bypass -File .\install\windows\bootstrap-current-repo-omx.ps1 -Force`
- If the user explicitly asks about machine-wide install, recommend the user-level installer instead.
- Do not fabricate unsupported OpenCode features.
