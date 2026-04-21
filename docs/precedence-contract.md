# Precedence Contract — User-Level vs Project-Level OMX for OpenCode

## Rule
For repo-specific behavior, **project-local OMX always wins** over user-level OMX.

## Why
The user-level install exists to make OMX available everywhere on a Windows machine.
The project-level install exists to define the actual behavior of a specific repository.

Without this contract, a machine-wide install could accidentally override a repo's intended workflow.

## Precedence order
1. Project-local `AGENTS.md`
2. Project-local `.omx\*` state and templates
3. Project-local `.opencode\agents\*` and `.opencode\commands\*` for repo behavior
4. User-level `~/.config/opencode\agents\*` and `commands\*` as machine defaults
5. Global plugins then project plugins, following OpenCode plugin load order

For plugins specifically, do **not** assume a hard override model. OpenCode loads global plugins before project plugins, so project plugins should narrow or add behavior rather than relying on deleting or replacing global plugin effects.

## Practical meaning
- If both user-level and project-level `omx` agents exist, the project copy is authoritative for that repo.
- If both user-level and project-level commands exist, the project copy is authoritative for that repo.
- If both user-level and project-level plugins exist, both may load; project plugins should be written to add repo-specific behavior without assuming global plugins are absent.
- `.omx\CONTEXT.md`, `.omx\PLAN.md`, `.omx\plans\*`, and `.omx\SESSION.log` are always repo-local state.

## Doctor expectation
Doctor must explicitly report:
- whether user-level OMX exists
- whether project-level OMX exists
- whether both exist
- whether project-level overrides are present where expected

## Bootstrap detection
User-level OMX should be available everywhere, but if a repo is missing its local OMX files, the correct behavior is to detect that and trigger or recommend project bootstrap rather than acting as if repo-local state already exists.

## Fresh repo auto-bootstrap
If a repo is missing the required local OMX files, user-level OMX should create the missing starter files on first use.
If `.omx` already exists but is incomplete, create only the missing starter files and do not overwrite existing repo state.
