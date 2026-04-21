import { appendFile, mkdir, readFile, stat, writeFile } from 'node:fs/promises'
import path from 'node:path'

const stamp = () => new Date().toISOString().replace(/\.\d{3}Z$/, 'Z')

const omxDirPath = (directory) => path.join(directory, '.omx')
const sessionLogPath = (directory) => path.join(directory, '.omx', 'SESSION.log')
const contextPath = (directory) => path.join(directory, '.omx', 'CONTEXT.md')
const plansDirPath = (directory) => path.join(directory, '.omx', 'plans')
const planPath = (directory) => path.join(directory, '.omx', 'PLAN.md')
const agentsPath = (directory) => path.join(directory, 'AGENTS.md')

const starterAgents = `# Windows OMX for OpenCode

This repository uses the Windows OMX single-agent workflow in OpenCode.

## Core flow
- @omx interview
- @omx plan
- @omx step <n>
- @omx verify

## Repo-local source of truth
- .omx\\CONTEXT.md
- .omx\\PLAN.md
- .omx\\SESSION.log

## Rules
- Prefer PowerShell for automation examples.
- Use Windows-style backslashes in operator-facing paths.
- Never continue to the next step until the current step verifies.
- Safe local verification commands should be run by the agent.
`

const starterContext = `# Project Context

## Objective
<fill during @omx interview>

## Why this exists
<fill during @omx interview>

## Windows execution context
- Preferred shell: PowerShell
- Line endings: CRLF or LF (confirm during interview)
- Workspace root: <fill during @omx interview>
- Tooling notes: <npm|dotnet|python|other>

## Constraints
- <fill during @omx interview>

## Non-goals
- <fill during @omx interview>

## Definition of Done
- <must be explicit before @omx plan>

## Decision boundaries
- <fill during @omx interview>
`

const starterPlan = `# Active Plan Pointer

- active_plan: none
- status: none
- task: none
- last_updated: ${stamp()}
- mode: interview
- next_gate: define task and create named plan

## Notes
- The real plan should be written to .omx\plans\<task-slug>.md.
- Update this pointer whenever a new active plan is created.
`

async function pathExists(target) {
  try {
    await stat(target)
    return true
  } catch {
    return false
  }
}

async function appendSessionLog(directory, kind, message) {
  await mkdir(omxDirPath(directory), { recursive: true })
  await appendFile(sessionLogPath(directory), `[${stamp()}] ${kind}: ${message}\n`, 'utf8')
}

async function safeExistsText(file) {
  try {
    return await readFile(file, 'utf8')
  } catch {
    return ''
  }
}

async function writeIfMissing(file, content) {
  if (!(await pathExists(file))) {
    await mkdir(path.dirname(file), { recursive: true })
    await writeFile(file, content, 'utf8')
    return true
  }
  return false
}

async function ensureRepoBootstrap(directory) {
  const created = []
  await mkdir(plansDirPath(directory), { recursive: true })
  if (await writeIfMissing(agentsPath(directory), starterAgents)) created.push('AGENTS.md')
  if (await writeIfMissing(contextPath(directory), starterContext)) created.push('.omx\\CONTEXT.md')
  if (await writeIfMissing(planPath(directory), starterPlan)) created.push('.omx\\PLAN.md')
  if (await writeIfMissing(sessionLogPath(directory), '')) created.push('.omx\\SESSION.log')
  if (created.length > 0) {
    await appendSessionLog(directory, 'hook-bootstrap', `Created starter OMX files: ${created.join(', ')}`)
  }
}

function summarizeCommandEvent(event) {
  const command = event?.properties?.command ?? event?.properties?.name ?? event?.command ?? 'unknown'
  return `command.executed -> ${command}`
}

function summarizeSessionEvent(event) {
  return `${event.type}`
}

export const OmxHooksPlugin = async ({ directory, client }) => {
  await ensureRepoBootstrap(directory)

  await client.app.log({
    body: {
      service: 'omx-hooks',
      level: 'info',
      message: 'OMX hook plugin initialized',
      extra: { directory },
    },
  })

  return {
    event: async ({ event }) => {
      if (!event?.type) return

      await ensureRepoBootstrap(directory)

      if (event.type === 'command.executed') {
        await appendSessionLog(directory, 'hook-event', summarizeCommandEvent(event))
        return
      }

      if (event.type.startsWith('session.')) {
        await appendSessionLog(directory, 'hook-event', summarizeSessionEvent(event))
      }
    },

    'tool.execute.before': async (input) => {
      const toolName = input?.tool ?? input?.name ?? ''
      if (toolName.toLowerCase() === 'task') {
        throw new Error('OMX single-agent mode forbids the Task tool / subagents in this project.')
      }
    },

    'experimental.session.compacting': async (_input, output) => {
      await ensureRepoBootstrap(directory)
      const context = await safeExistsText(contextPath(directory))
      const plan = await safeExistsText(planPath(directory))

      output.context.push(`\n## Windows OMX Hook Context\nPreserve the current Windows OMX state when compacting:\n- Source of truth files: .omx\\CONTEXT.md, .omx\\PLAN.md, .omx\\SESSION.log\n- Single-agent rule: never use Task/subagents\n- Keep Windows execution assumptions explicit (PowerShell vs CMD, paths, line endings)\n\n### CONTEXT excerpt\n${context.slice(0, 1200)}\n\n### PLAN excerpt\n${plan.slice(0, 1200)}\n`)
    },
  }
}
