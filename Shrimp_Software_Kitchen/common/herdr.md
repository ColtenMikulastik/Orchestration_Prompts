# Running agents with herdr

Shared by both kitchens. The orchestrator reads this file at the start of the run.

You run inside a herdr pane. Check with `[ "$HERDR_ENV" = 1 ]`. If it isn't set, tell the user, and fall back to your tool's own subagent feature, one agent at a time.

If a herdr command's output doesn't match what is written here, run `herdr <command> --help`, adapt, and tell the user.

## Layout

- One herdr tab per task, labelled with the task ID (for example `T7`).
- The agents for a task run as panes in that task's tab.
- At most two agent panes are open at once. Your own pane doesn't count.
- Close an agent's pane as soon as its report is in. Close the task's tab when the task is `done`.
- Leave the panes of a `blocked` task open so the user can look at them.

## Names

Name every agent `<role>-<task id>`, all lowercase: `tester-t7`, `tooler-t7`, `evaluator-t7`. Use letters, digits and hyphens only.

- Names must be unique among live agents. If a name is taken, add a suffix: `tooler-t7-2`.
- Agents that serve the whole run have no task ID. Name them as the prompt for that kitchen says.

## Starting an agent

Create the tab, then start the agent in its pane. Wait about 4 seconds after creating a pane before starting an agent in it.

```bash
tab=$(herdr tab create --workspace <workspace id> --cwd <project dir> --label T7 --no-focus)
# take the new pane's id from $tab (check the output shape the first time)
herdr agent start tooler-t7 --kind <kind> --pane <pane id>
```

For a second agent in the same task, split the first pane:

```bash
split=$(herdr pane split <first pane id> --direction right --ratio 0.5 --no-focus --cwd <project dir>)
pane=$(printf '%s\n' "$split" | jq -r '.result.pane.pane_id')
herdr agent start evaluator-t7 --kind <kind> --pane "$pane"
```

Use the same `--kind` as yourself unless the user said otherwise. If the user gave agent arguments (for example a cheaper model for the tooler), pass them after `--`.

Get the workspace id once, from `herdr pane current` or `herdr workspace list`, and reuse it.

## Giving work and waiting

The first prompt to each agent tells it to read its role file and then gives the task details. Also give it the path where its report must go.

```bash
herdr agent prompt tooler-t7 "<prompt>" --wait --timeout 900000
```

Timeouts in milliseconds:
- tester and evaluator: `300000`
- tooler: `900000`

Never wait without a timeout. Never poll in a loop, and never sleep (the only pause is the 4 seconds after creating a pane).

When the wait ends:

- **done or idle:** read the report file. If it doesn't exist, read the agent's recent output (`herdr agent read tooler-t7 --source recent-unwrapped --lines 30`) and prompt it to write the report.
- **blocked:** the agent is waiting on a question or an approval. Read its last 30 lines. If it's a question about the task, answer it with `herdr agent prompt`. If it's a permission or approval request, don't answer it: tell the user which pane needs them.
- **timeout (the command exits with status 1):** read `herdr agent get tooler-t7` and its last 30 lines. If it's still working, wait once more with `herdr agent wait tooler-t7 --timeout 900000`. If it times out again, stop. Tell the user the pane name, the last lines it printed, and what it was doing. Don't wait a third time.

Send follow-ups to the same agent with `herdr agent prompt ... --wait`. It still has the task in context.

## Running tests

Run tests yourself in your own shell, or have an evaluator run them, using the check command from `design/stack.md`. Always put a timeout on the command:

```bash
timeout 300 <check command from design/stack.md>
```

If the command is killed by the timeout, that counts as a failure: "timed out". Report the suite that was running. The timeout is set in the Limits section of each kitchen's orchestrator prompt.

## Cleanup

- Close an agent's pane: `herdr pane close <pane_id>`.
- Close a task's tab: `herdr tab close <tab_id>`.
- Herdr has no command to stop an agent. Closing its pane does that.
- If you lose track of an agent, `herdr agent list` shows the live ones.
