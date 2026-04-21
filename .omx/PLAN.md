# oh-my-opencode v1 Plan

## Preconditions
- Work only from user-provided files, outputs, and the three `.omx\` artifacts.
- Keep the workflow single-agent and manually verified.
- Do not begin a later step before the current step is verified.
- Use Windows-style paths in operator-facing instructions.

## State-machine rules
- Exactly one step may be `in-progress` during active execution.
- A step becomes `done` only after pasted evidence satisfies its `verify` field.
- Oversized steps must be split before execution.
- `@omx verify` returns only `PASS`, `FAIL`, or `REPLAN`.

## Steps
### Step 1
- goal: Define the reusable `.omx\` artifact templates.
- touchpoints: `.omx\templates\CONTEXT.template.md`, `.omx\templates\PLAN.template.md`, `.omx\templates\SESSION.template.log`
- output: Copy-pastable starter files for context, plan, and session logging.
- verify: `Test-Path .omx\templates\CONTEXT.template.md; Test-Path .omx\templates\PLAN.template.md; Test-Path .omx\templates\SESSION.template.log`
- pass_condition: Files exist and contain the mandatory headings/fields documented in the PRD.
- fail_condition: Any template file is missing or omits required sections.
- status: done

### Step 2
- goal: Define the exact response contract for the four `@omx` commands.
- touchpoints: `docs\command-response-templates.md`
- output: Literal response templates and behavior rules for interview, plan, step, and verify.
- verify: `Select-String -Path docs\command-response-templates.md -Pattern '@omx interview','@omx plan','@omx step \[n\]','@omx verify','PASS\|FAIL\|REPLAN'`
- pass_condition: All four command contracts are present and match the PRD/test spec.
- fail_condition: Any command is missing or violates the hard-stop rules.
- status: done

### Step 3
- goal: Define the pilot walkthrough and interruption/resume proof.
- touchpoints: `docs\pilot-workflow.md`
- output: A documented scenario covering happy path, failed verify, and resume.
- verify: `Select-String -Path docs\pilot-workflow.md -Pattern 'happy path','Failed verification path','Interruption and resume','REPLAN'`
- pass_condition: The walkthrough covers all required phases and references the `.omx\` artifacts.
- fail_condition: The pilot omits one of the required proof points.
- status: done

### Step 4
- goal: Materialize the live `.omx\` files with a completed example instance.
- touchpoints: `.omx\CONTEXT.md`, `.omx\PLAN.md`, `.omx\SESSION.log`
- output: Ready-to-read live artifacts showing the protocol in use.
- verify: `Test-Path .omx\CONTEXT.md; Test-Path .omx\PLAN.md; Test-Path .omx\SESSION.log`
- pass_condition: A fresh session could read the three files and reconstruct current state.
- fail_condition: Resume information is incomplete or inconsistent.
- status: done

### Step 5
- goal: Validate the artifacts against the approved test spec and Windows protocol requirements.
- touchpoints: `.omx\CONTEXT.md`, `.omx\PLAN.md`, `.omx\SESSION.log`, `.omx\templates\*`, `docs\command-response-templates.md`, `docs\pilot-workflow.md`
- output: Fresh verification evidence recorded in the session log.
- verify: `powershell -ExecutionPolicy Bypass -File .omx\verify-windows-protocol.ps1`
- pass_condition: Verification checks pass and the success evidence is appended to `.omx\SESSION.log`.
- fail_condition: Any required check fails or evidence is missing.
- status: done
