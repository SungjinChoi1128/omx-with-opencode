# oh-my-opencode v1 Context

## Objective
Create a Copilot-only operating model for Windows OpenCode that preserves the discipline of OMX using a markdown protocol instead of subagents.

## Why this exists
OMX's value comes from interview -> planning -> mechanically gated execution. In a Windows OpenCode + GitHub Copilot environment, that discipline must be carried by explicit files, Windows-aware command contracts, and a single-agent loop.

## Constraints
- GitHub Copilot only
- No subagents
- No extra plugins required for v1
- No background orchestration
- No autonomous retry loops
- No repository crawling in v1
- No external web/doc/MCP lookups in v1
- Prefer PowerShell for automation examples and scripts
- Use Windows-style backslashes (`\`) when describing workspace file paths
- Clarify Windows-specific execution constraints during interview (PowerShell vs CMD, CRLF expectations, absolute Windows paths)

## Non-goals
- Reproducing autonomous self-healing
- Parallel or team execution
- Simulated multi-agent debate
- Hidden background work while the user waits
- Any baseline workflow that depends on extensions beyond chat + markdown files

## Decision boundaries
- Never provide implementation for step `n+1` before step `n` verifies.
- Reopen interview/planning when active context exceeds roughly 5–7 files.
- Require explicit confirmation before modifying `.gitignore`, `.env`, or CI/CD-sensitive config.
- Refuse to plan until the Definition of Done is fully clear in ` .omx\CONTEXT.md `.

## Hard-stop rules
1. No next-step batching.
2. No autonomous retries after failed verification.
3. No repository crawling in v1.
4. No external docs/web fetches in v1.
5. Sensitive config changes require explicit confirmation.
6. Replan instead of coding when the context ceiling is exceeded.
7. Ask about Windows shell context before planning if it is not already explicit.

## Assumptions
- Manual gates are acceptable if they prevent silent drift.
- The user is willing to paste verification evidence back into chat.
- Simplicity is more important than convenience in v1.
- PowerShell is the preferred Windows shell unless the user explicitly says otherwise.

## Resume protocol
1. Read this file first for constraints, non-goals, boundaries, and hard-stop rules.
2. Read `.omx\PLAN.md` to identify the last completed step and the next legal step.
3. Read the latest timestamped entry in `.omx\SESSION.log` for the last verified outcome.
4. If the next action would require more than 5–7 active files, reopen planning instead of continuing execution.
5. If the next action touches `.gitignore`, `.env`, or CI/CD-sensitive config, require explicit confirmation before proceeding.

## Verification policy
- Every plan step must declare its own Windows-compatible `verify` command or evidence requirement before execution.
- `@omx verify` may return only `PASS`, `FAIL`, or `REPLAN`.
- No step becomes `done` without pasted evidence satisfying the current step's `verify` field.

## Current implementation status
The initial oh-my-opencode v1 protocol pack has been authored in this repository, including reusable templates, Windows-aware command-response templates, and a pilot walkthrough.
