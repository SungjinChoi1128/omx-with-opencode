# Final Analysis — OMX Parity Under GitHub Copilot + No Subagents

## Goal of this analysis

Validate two things:

1. Whether this pack replicates **most of the practical OMX experience** despite the hard constraint of **GitHub Copilot without subagents**.
2. Whether the resulting pack is actually suitable for **Windows 11 OpenCode** usage.

---

## Executive conclusion

**Yes — this pack replicates most of the user-visible OMX workflow that matters for disciplined engineering, while intentionally not replicating multi-agent internals.**

The right way to think about it is:

A key enabling decision is the explicit **precedence contract**: project-local OMX must win over user-level OMX for repo behavior.

- **Not** “OMX internals ported to OpenCode”
- **Yes** “OMX operating experience recreated for a single-agent Windows OpenCode environment”

That distinction is important.

What we preserved is the **behavioral contract**:
- interview before planning
- brownfield codebase grounding before the next interview question
- planning before execution
- explicit chunk/gate execution
- verification before forward progress
- agent-executed local verification when safe
- persistent project state
- plugin hooks for session/command logging and single-agent enforcement
- strong operating rules in the agent prompt

What we intentionally dropped is the **orchestration substrate**:
- no subagents
- no hidden task spawning
- no background execution lanes
- no autonomous self-healing loops

For a GitHub Copilot subscription environment, that tradeoff is the correct one.

---

## 1. OMX parity analysis

### 1.1 What “most of OMX” means here

If the goal is to reproduce the **feeling and discipline** of OMX, the key layers are:

1. **Rules layer** — strong project instructions
2. **Flow layer** — interview → plan → execute → verify
3. **State layer** — durable files that survive context loss
4. **Verification layer** — no forward progress without proof
5. **UX layer** — the user knows exactly what to type next

This pack covers all five.

### 1.2 OMX features effectively preserved

#### A. Strong instruction surface
Implemented through:
- `AGENTS.md`
- `.opencode\agents\omx.md`
- `.opencode\commands\*.md`
- user-level `opencode.json` seeding when no global config exists yet

Effect:
- OpenCode receives a strongly constrained operating policy
- the primary agent behaves like an OMX architect/planner/executor loop
- the user experience is consistent and opinionated

#### B. Phase-gated flow
Implemented through:
- `@omx interview`
- `/omx-plan`
- `@omx step <n>`
- `/omx-verify`

Effect:
- the model does not freewheel
- work advances in explicit gates
- the user always knows the next control surface

#### C. Persistent state
Implemented through:
- `.omx\CONTEXT.md`
- `.omx\PLAN.md` (active-plan pointer)
- `.omx\plans\<task-slug>.md` (named active/history plans)
- `.omx\SESSION.log`

Effect:
- session loss is survivable
- project state is legible to both human and model
- long tasks do not depend on hidden chat memory

#### D. Mechanical verification gate
Implemented through:
- per-step verify commands in `.omx\PLAN.md`
- `PASS | FAIL | REPLAN`
- refusal to advance without successful verification evidence

Effect:
- this preserves one of the most important practical benefits of OMX
- reduces hallucinated progress
- keeps the system honest

#### E. UX similarity
Implemented through:
- mention-based flow (`@omx ...`)
- slash-command flow (`/omx-...`)
- a project-local `omx` agent

Effect:
- the system feels like a productized workflow rather than an ad hoc prompt
- end users do not need to memorize large manual instructions every session

### 1.3 OMX features intentionally not preserved

These are **not bugs**. They are correct exclusions under the Copilot-only constraint.

#### A. Subagent delegation
Not preserved because:
- the target environment disallows subagents
- trying to simulate them would produce fake rigor, not real rigor

Decision quality:
- correct

#### B. Autonomous self-healing loops
Not preserved because:
- they spend tokens without explicit user visibility
- they are less predictable in a single-agent environment

Decision quality:
- correct for Copilot-only workflow safety

#### C. Multi-lane parallel execution
Not preserved because:
- the pack is explicitly single-agent
- Windows OpenCode UX is better served by deterministic sequential gates

Decision quality:
- correct

### 1.4 Final parity judgment

**Behavioral parity: high**

**Architectural parity: intentionally low**

That is the correct design choice.

This pack reproduces the **discipline, hooks, statefulness, and user journey** of OMX far more than it reproduces its internal orchestration. For the stated constraint, that is exactly what “best way” should mean.

---

## 2. Windows 11 suitability analysis

### 2.1 Windows-specific requirements addressed

The pack is now explicitly Windows-aware in all critical layers.

#### A. Path style
- operator-facing examples use backslashes
- `.omx\...` and `.opencode\...` paths are used throughout docs and commands

#### B. Preferred shell
- PowerShell is the default automation shell
- the verification harness is a `.ps1` script

#### C. Interview constraints
The interview phase now explicitly asks about:
- PowerShell vs CMD
- CRLF vs LF
- important Windows paths
- tooling assumptions

#### D. Verification commands
Plan and command examples use Windows-compatible verification patterns such as:
- `Test-Path`
- `Get-Content`
- `Select-String`
- `npm test`
- `dotnet test`

### 2.2 Windows installer suitability

The design now uses a hybrid install model:
- **user-level install** in `~/.config/opencode` for machine-wide OMX availability
- **project-level bootstrap** inside the repo for repo-specific state and rules


The PowerShell installer at:
- `install\windows\install-opencode-omx.ps1`

is the correct convenience layer because it:
- installs into an existing repo
- respects project-local OpenCode extension points
- can avoid overwriting by default
- supports `-Force`
- creates starter `.omx` files if needed

This is better than “just tell the LLM what to do” because:
- it eliminates manual copy mistakes
- it standardizes the pack across users
- it gives teams a repeatable installation story

### 2.3 Verified Windows evidence

Fresh evidence already gathered in this repository showed:
- the installer successfully copied the pack into a fresh target repo
- the Windows protocol verifier returned `PASS`
- total checks passed: **18**

That means the install path is not theoretical; it was exercised.

### 2.4 Residual Windows risks

There are still a few realistic risks to call out.

#### A. Shell confusion
A user may run the `.ps1` file from Git Bash / sh instead of PowerShell.

Mitigation:
- docs now explicitly say to use PowerShell
- the installer and README show PowerShell examples

#### B. PowerShell execution policy
Some environments restrict script execution.

Mitigation:
- documented invocation uses:
  - `powershell -ExecutionPolicy Bypass -File ...`

#### C. OpenCode version drift
If OpenCode changes agent/command conventions later, the pack may need updating.

Mitigation:
- the pack uses OpenCode’s documented native extension points today
- project-local install makes upgrades controlled and reviewable

---

## 3. Best installation recommendation

### Recommended answer

**Use a project-local install pack, delivered by a Windows PowerShell installer.**

That is better than either extreme:

#### Worse option A — “Just give users prompting guidance”
Problems:
- too fragile
- too dependent on manual repetition
- easy to drift across users and repos
- not productized enough

#### Worse option B — “Build a separate full plugin first”
Problems:
- much more engineering work
- unnecessary because OpenCode already has native rules/agent/command surfaces
- too much ceremony for v1

### Why the chosen approach is best

It combines:
- **native OpenCode integration**
- **Windows-friendly automation**
- **team-sharable repo-local files**
- **single-agent safety**
- **clear OMX-like user experience**

That is the best fit for the constraints you gave.

---

## 4. Final verdict

### On parity with OMX
**Pass, with the correct interpretation.**

This pack reproduces most of the **practical OMX operating experience** while deliberately not reproducing multi-agent internals.

### On Windows 11 compatibility
**Pass.**

The workflow, docs, commands, path style, verification harness, and installer are all now Windows-oriented, and the install path has been exercised successfully.

### On installation approach
**Best choice implemented:**
- project-local OpenCode pack
- optional Windows PowerShell installer
- no separate plugin build required for v1

---

## Recommended next evolution

If you want a v2, the next best improvements would be:
1. a one-line bootstrap installer command for end users
2. a `.cmd` shim that launches the PowerShell verifier for less technical users
3. a small upgrade script to refresh an installed pack in place
4. optional company-default global rules layered on top of the project-local install
