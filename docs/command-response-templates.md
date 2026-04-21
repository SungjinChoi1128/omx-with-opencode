# oh-my-opencode Command Response Templates (Windows OpenCode)

These are literal response contracts for the four v1 protocol keywords in a Windows OpenCode environment.

Bootstrap rule: if a repo is missing the required local OMX files, the hook/plugin layer should create the starter repo-local files mechanically before continuing. If `.omx` already exists, fill in only the missing starter files and never overwrite existing repo state. Named plans live in `.omx\plans\<task-slug>.md`, while `.omx\PLAN.md` points to the currently active plan. Interview creates clarification artifacts only; planning creates the real named execution plan.

## `@omx interview`

### Purpose
Stop coding and clarify intent, scope, constraints, non-goals, definition of done, and Windows execution context.

### Required behavior
- Do not propose implementation until ambiguity is low enough to plan.
- Ask only the highest-leverage unresolved question.
- Update or produce `.omx\CONTEXT.md` before moving on.
- Create/update clarification artifacts under `.omx\context\...`, `.omx\interviews\...`, and optionally `.omx\specs\...`.
- In an existing repo, inspect relevant files and likely touchpoints before asking the next question.
- Record discovered codebase facts in the clarification artifacts.
- Ask evidence-backed questions that reference those facts.
- Explicitly identify Windows constraints when not already known: PowerShell vs CMD, CRLF vs LF, and important Windows paths.
- Refuse to plan until the Definition of Done is explicit.
- Do **not** create the real named execution plan in interview mode.

### Response template
```text
MODE: interview
TARGET: <intent|outcome|scope|constraints|definition-of-done|windows-context>

What I know:
- <fact>
- <fact>

Repo facts found:
- <file/pattern/finding>
- <file/pattern/finding>

Windows context to confirm:
- shell: <PowerShell|CMD|unknown>
- line endings: <CRLF|LF|unknown>
- important path: <C:\path	o
epo|unknown>

Question:
<single question>
```

## `/omx-plan`

### Purpose
Produce or update a named plan in `.omx\plans\<task-slug>.md` and keep `.omx\PLAN.md` as the active-plan pointer.

### Required behavior
- Create meaningful chunks/milestones instead of approval-only microsteps.
- A chunk may include multiple safe local edits and local checks.
- Include a Windows-compatible `verify` field and a gate type for every chunk.
- Split or replan if the task would exceed the context ceiling.
- Do not invent missing repository context; ask the user for the needed file/output or return `REPLAN`.
- Do **not** start execution from plan mode. Planning must stop at an explicit handoff.

### Response template
```text
MODE: plan
PLAN STATUS: drafted|updated|replanned

Plan file: `.omx\plans\<task-slug>.md`
Active pointer: `.omx\PLAN.md`

Chunks:
[ ] 1. <chunk title>
    Verify (Windows): <Test-Path|dir|npm test|dotnet test|other Windows-compatible command>
    Gate: <none|manual|external|risky|replan>
[ ] 2. <chunk title>
    Verify (Windows): <command>
    Gate: <gate type>

Protocol checks:
- One active step at a time
- No next-step batching
- Replan if >5–7 active files
- Stop after plan creation and hand off to `/omx-execute` or `/omx-step <n>`
```

## `/omx-execute`

### Purpose
Continue the active named plan end-to-end until the next real gate.

### Required behavior
- Resolve the active named plan from `.omx\PLAN.md`.
- Continue across multiple chunks until a real gate is reached.
- Run safe local verification commands yourself.
- Ask the user to run verification only when manual, GUI, external, or long-lived execution is required.
- If no active named plan exists, direct the user to `/omx-plan`.

### Response template
```text
MODE: execute
PLAN: <active named plan>
CURRENT CHUNK: <n>

Work completed in this pass:
- <edit/check>
- <edit/check>

Gate reached:
- <none|manual|external|risky|replan>

Verification execution:
- <command and real output, or reason the user must run it manually>
```

## `@omx step [n]`

### Purpose
Execute the requested chunk/milestone and stop only at its declared gate.

### Required behavior
- Do not include future chunks beyond the requested chunk.
- Provide all code or file changes needed to complete the requested chunk.
- Provide the exact Windows-compatible verification command.
- If the command is safe, local, and non-destructive, execute it yourself and include the actual output.
- Ask the user to run it only when it needs manual interaction, GUI context, external credentials/systems, or a long-lived process.
- End with a validation checklist.
- Restate the exact verification requirement that must succeed next.
- If the user pastes a Windows terminal error, fix only the current step and update `.omx\PLAN.md` when necessary.

### Response template
```text
MODE: step
CHUNK: <n>
GOAL: <meaningful bounded milestone>
TOUCHPOINTS: <Windows-style paths or allowed outputs>

Implementation:
<only the content for step n>

Verify (Windows):
<powershell/cmd-compatible command>

Verification execution:
- <agent-ran command and actual output, or reason the user must run it manually>

Validation checklist:
- <check 1>
- <check 2>

Next verify requirement:
<the current chunk must reach its declared gate; if manual verification is required, paste the resulting output>
```

## `/omx-verify`

### Purpose
Compare the available evidence only against the current step's declared `verify` field.

### Required behavior
- Return only `PASS`, `FAIL`, or `REPLAN`.
- Base the verdict only on the current step's `verify` field and the available evidence.
- Prefer agent-executed verification when the command is safe and local; otherwise use the user's manually provided evidence.
- Never advance the plan on `FAIL`.
- Safe local verification commands should usually be run by the agent, not pushed back to the user.
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
