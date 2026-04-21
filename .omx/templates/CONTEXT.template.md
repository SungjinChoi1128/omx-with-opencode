# <Project Name> Context

## Objective
<What are we trying to achieve?>

## Why this exists
<Why this work matters now>

## Windows execution context
- Preferred shell: <PowerShell|CMD>
- Line endings: <CRLF|LF>
- Workspace root: <C:\path\to\repo>
- Tooling notes: <npm|dotnet|python|other>

## Constraints
- <constraint 1>
- <constraint 2>

## Non-goals
- <explicitly out of scope>
- <explicitly out of scope>

## Definition of Done
- <observable success condition>
- <observable success condition>

## Decision boundaries
- <what the assistant must not decide alone>
- <when to reopen planning>

## Hard-stop rules
1. No next-step batching.
2. No autonomous retries after failed verification.
3. No repository crawling unless the protocol explicitly allows it.
4. No external docs/web fetches unless the protocol explicitly allows them.
5. No sensitive config edits without explicit confirmation.
6. Reopen planning if the task exceeds the active-context ceiling.

## Assumptions
- <assumption>
- <assumption>

## Resume protocol
1. Read this file first.
2. Read `.omx\PLAN.md` for current state.
3. Read the latest entry in `.omx\SESSION.log` for the last verified outcome.
4. Reopen planning if a hard-stop rule would be violated.

## Verification policy
- Each step must declare a Windows-compatible verify requirement before execution.
- `@omx verify` returns only `PASS`, `FAIL`, or `REPLAN`.
- No step becomes `done` without pasted evidence.
