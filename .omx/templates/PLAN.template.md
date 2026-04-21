# <Project Name> Plan

## Preconditions
- <required setup>
- <required context>

## State-machine rules
- Exactly one step may be `in-progress`.
- A step becomes `done` only after pasted evidence satisfies its `verify` field.
- Oversized steps must be split before execution.
- `@omx verify` returns only `PASS`, `FAIL`, or `REPLAN`.

## Steps
### Step <n>
- goal: <single bounded outcome>
- touchpoints: <Windows-style file paths or operator outputs>
- output: <what will exist after the step>
- verify: <Windows-compatible command such as Test-Path, Get-Content, npm test, dotnet test>
- pass_condition: <what counts as PASS>
- fail_condition: <what counts as FAIL>
- status: pending|in-progress|blocked|done
