# OMX Behavioral Parity Matrix — OpenCode + GitHub Copilot + Windows 11

This matrix compares the target behavioral surfaces from `oh-my-codex` to this OpenCode pack.

Legend:
- **Replicate** — implemented directly in OpenCode
- **Adapt** — reproduced with a single-agent/OpenCode-compatible alternative
- **Out of scope** — intentionally omitted because it depends on subagents/tmux/runtime internals

| Surface | oh-my-codex baseline | OpenCode pack target | Status | Notes |
| --- | --- | --- | --- | --- |
| Global/user install | `omx setup` installs user surfaces | Windows user-level installer into `~/.config/opencode` | Replicate | Implemented via PowerShell scripts |
| First-use repo bootstrap | OMX setup/project scope + generated AGENTS | User-level hook plugin creates missing starter files mechanically on first use | Adapt | Keeps new-repo UX close to OMX and avoids prompt-only bootstrap drift |
| Project bootstrap | `omx setup --scope project` + generated AGENTS | Project installer/bootstrap into repo | Replicate | Existing installer retained and wrapped |
| Project guidance | Scoped `AGENTS.md` | Repo `AGENTS.md` | Replicate | Project-local authority remains highest |
| Primary workflow | `$deep-interview` -> `$ralplan` -> `$ralph` | `@omx interview` -> `/omx-plan` -> `/omx-execute` -> `/omx-verify` | Adapt | Single-agent flow preserves gates, but steps map to execution chunks rather than tiny approvals |
| Commands UX | OMX commands/skills | OpenCode slash commands + mention flow | Adapt | OpenCode-native command format |
| Prompt/rules layer | AGENTS + prompts + skills | `omx` agent + command prompts + AGENTS + safe global `instructions` seeding | Adapt | Single primary agent instead of prompt catalog |
| Verification gate | Ralph verification loop | PASS/FAIL/REPLAN with agent-run local verification when safe, otherwise manually provided evidence | Replicate | Mechanical gate preserved without needless user shell handoff |
| Session persistence | `.omx/` state and logs | `.omx\CONTEXT.md`, `.omx\PLAN.md`, `.omx\plans\<task-slug>.md`, `.omx\SESSION.log` | Replicate | Core state files preserved with named plan history |
| Hook lifecycle | native hooks + notify/runtime hooks | OpenCode plugin hooks | Adapt | Uses plugin events instead of Codex native hooks |
| Compaction continuity | native compaction hook | plugin compaction hook injects OMX context | Adapt | Supported by plugin API |
| Setup surface | `omx setup` | PowerShell setup/install scripts + `/omx-setup` help command | Adapt | Windows/OpenCode-specific |
| Doctor surface | `omx doctor` | PowerShell doctor script + `/omx-doctor` help command | Adapt | Checks user + project installs |
| Update surface | `omx update` | PowerShell update script + `/omx-update` help command | Adapt | Force-refresh install path |
| Cancel/help surfaces | OMX skills/commands | `/omx-cancel`, `/omx-help` | Adapt | Chat-layer equivalents |
| User-level precedence | user + project install scopes | explicit precedence contract | Replicate | Project-local wins |
| Windows-first support | secondary in OMX | primary in this pack | Adapt | PowerShell-first, backslashes, Win11 validation |
| Subagents | native Codex subagents | none | Out of scope | Hard constraint: Copilot only |
| tmux/team runtime | OMX runtime/team surfaces | none | Out of scope | Cannot honestly reproduce in OpenCode + no subagents |
| Autonomous self-healing | Ralph persistence loop with subagents/runtime | none | Out of scope | Replaced by explicit user verification loop |
