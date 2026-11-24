# prompts

Version-controlled prompts for Odin and the agents it spawns. This directory is the `Odin/` folder of the `orchestration-prompts` git repo. It tracks **only prompts**; Odin's state (registry, tasks, logs) lives in `~/odin/` and is not versioned.

The files are meant to be *used* from elsewhere (e.g. `~/Odin.md`), so they are exposed through symlinks. The repo is the single source of truth; the symlinks are just pointers.

## Setting up the symlinks (new machine or fresh clone)

```bash
git clone https://github.com/ColtenMikulastik/Orchestration_Prompts ~/projects/orchestration-prompts   # skip if already there
mkdir -p ~/odin/tasks ~/odin/logs            # state dir (untracked)
~/projects/orchestration-prompts/Odin/link.sh --dry-run # preview
~/projects/orchestration-prompts/Odin/link.sh           # create the links
```

`link.sh` is idempotent: it creates missing links, leaves correct ones alone (`ok`), and **never overwrites** an existing real file. It prints `SKIPPED` instead, so move the old file aside and re-run.

## How it works

`links.txt` is the manifest, one `source target` pair per line (`#` for comments, `~` expands to `$HOME`). The source is relative to this directory.

```
Odin.md    ~/Odin.md
.          ~/odin/prompts
```

To expose a new prompt, add a line (e.g. `dev.md  ~/.claude/prompts/dev.md`) and run `link.sh`.

## Rules

- Edit prompts here, in `~/projects/orchestration-prompts/Odin/`, never through a replacement of the symlink (don't `mv`/`cp` a new file over `~/Odin.md`, or you replace the link with a loose copy that git doesn't track). Editing through the link with an editor or `Edit` is fine.
- Commit changes in this repo, not in `~`. `~` is not a repo.
- No secrets in prompts.

## Contents

| file | purpose |
|------|---------|
| `Odin.md` | The central orchestrator prompt |
| `links.txt` | Symlink manifest |
| `link.sh` | Creates the symlinks from the manifest |
