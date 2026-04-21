# oh-my-opencode Command Response Templates (Windows OpenCode)

These are literal response contracts for the four v1 protocol keywords in a Windows OpenCode environment.

## `@omx interview`

### Purpose
Stop coding and clarify intent, scope, constraints, non-goals, definition of done, and Windows execution context.

### Required behavior
- Do not propose implementation until ambiguity is low enough to plan.
- Ask only the highest-leverage unresolved question.
- Update or produce `.omx\CONTEXT.md` before moving on.
- Explicitly identify Windows constraints when not already known: PowerShell vs CMD, CRLF vs LF, and important Windows paths.
- Refuse to plan until the Definition of Done is explicit.

### Response template
```text
MODE: interview
TARGET: <intent|outcome|scope|constraints|definition-of-done|windows-context>

What I know:
- <fact>
- <fact>

Windows context to confirm:
- shell: <PowerShell|CMD|unknown>
- line endings: <CRLF|LF|unknown>
- important path: <C:\path	oepo|unknown>

Question:
<single question>
```

## `@omx plan`

### Purpose
Produce or update `.omx\PLAN.md` as a strict sequential state machine.

### Required behavior
- Keep every step small enough for one Copilot response.
- Use checkbox-style or clearly sequential atomic steps.
- Include a Windows-compatible `verify` field for every step.
- Split or replan if the task would exceed the context ceiling.
- Do not invent missing repository context; ask the user for the needed file/output or return `REPLAN`.

### Response template
```text
MODE: plan
PLAN STATUS: drafted|updated|replanned

Steps:
[ ] 1. <step title>
    Verify (Windows): <Test-Path|dir|npm test|dotnet test|other Windows-compatible command>
[ ] 2. <step title>
    Verify (Windows): <command>

Protocol checks:
- One active step at a time
- No next-step batching
- Replan if >5–7 active files
```

## `@omx step [n]`

### Purpose
Generate only the requested step and nothing from later steps.

### Required behavior
- Do not include step `n+1` implementation content.
- Provide the code or file content needed only for step `n`.
- Provide the exact Windows-compatible verification command.
- End with a validation checklist.
- Restate the exact verification requirement the user must satisfy next.
- If the user pastes a Windows terminal error, fix only the current step and update `.omx\PLAN.md` when necessary.

### Response template
```text
MODE: step
STEP: <n>
GOAL: <single bounded outcome>
TOUCHPOINTS: <Windows-style paths or allowed outputs>

Implementation:
<only the content for step n>

Verify (Windows):
<powershell/cmd-compatible command>

Validation checklist:
- <check 1>
- <check 2>

Next verify requirement:
<paste the successful output of the verification command>
```

## `@omx verify`

### Purpose
Compare pasted evidence only against the current step's declared `verify` field.

### Required behavior
- Return only `PASS`, `FAIL`, or `REPLAN`.
- Base the verdict only on the current step's `verify` field and the pasted evidence.
- Never advance the plan on `FAIL`.
- On `REPLAN`, stop coding and return to planning/decomposition.
- When relevant, cite the Windows command that was expected.

### Response template
```text
MODE: verify
VERDICT: PASS|FAIL|REPLAN
STEP: <current step>
EXPECTED COMMAND: <Windows-compatible verify command>
REASON: <brief reason tied directly to the step's verify field>
NEXT ACTION: <mark done | revise current step | reopen planning>
```

## Hard-stop reminders
- Never emit step `n+1` before step `n` verifies.
- Never autonomously retry after a failed verify.
- Never crawl the repo or fetch external docs in v1.
- Never edit `.gitignore`, `.env`, or CI/CD-sensitive config without explicit confirmation.
- Prefer PowerShell (`.ps1`) for automation examples.
- Use Windows-style backslashes (`\`) in operator-facing paths.
