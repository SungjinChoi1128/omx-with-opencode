# Active Plan Pointer

- active_plan: <.omx\plans\task-slug.md or none>
- status: none|active|blocked|complete|archived
- task: <short task summary>
- last_updated: <ISO-8601 timestamp>
- mode: interview|plan|step|verify
- next_gate: <manual verification | external dependency | risky/destructive approval | none>

## Usage
- This file is the **current active-plan pointer**, not the full plan history.
- Store the actual named plan in `.omx\plans\<task-slug>.md`.
- Update this pointer whenever the active plan changes.
