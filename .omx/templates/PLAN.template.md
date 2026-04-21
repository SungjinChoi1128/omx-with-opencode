# Plan: <task-slug>

Status: active
Created: <ISO-8601 timestamp>
Task: <short task summary>
Definition of Done: <explicit completion target>

## Execution rules
- This file is the **named plan** for one task.
- `@omx step <n>` refers to a **chunk** or **milestone**, not a micro-edit.
- Each chunk may include multiple safe local edits and local verification steps.
- Pause only at a real gate:
  - manual verification
  - GUI/manual interaction
  - external credentials/systems
  - risky/destructive action
  - replan boundary
- Safe local verification should be executed by the agent whenever possible.

## Chunks
### Chunk <n>
- goal: <meaningful bounded milestone>
- touchpoints: <Windows-style file paths or operator outputs>
- internal_work: <multiple safe local edits/checks allowed>
- verify: <Windows-compatible command or manual evidence requirement>
- gate_type: none|manual|external|risky|replan
- pass_condition: <what counts as PASS>
- fail_condition: <what counts as FAIL>
- status: pending|in-progress|blocked|done
