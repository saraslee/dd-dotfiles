# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository that gets applied when provisioning new Datadog devservers. The goal is to set up a new devserver with minimal effort — shell environment, git config, editor settings, and utilities are all deployed automatically.

## Key Files

- `install.sh` — Workspace bootstrap script: symlinks all dotfiles (files starting with `.`) from `~/dotfiles` to `$HOME` and installs zshmarks plugin. Runs automatically when a workspace is created.
- `setup-agents.sh` — Clones the private `DataDog/experimental` repo and runs `users/sara.lee/scripts/install.sh` to set up Claude Code agents. Must be run manually after `install.sh` since it requires access to the private repo.
- `.zshrc` — Shell config: oh-my-zsh with "robbyrussell" theme, git + zshmarks plugins, direnv integration
- `.my-aliases` — Shell aliases for kubectl, Bazel tidy, Claude Code, zshmarks bookmarks, and ddtool auth
- `.gitconfig` — Git config with SSH commit signing, URL rewrite for private DataDog repos (`git@github.com:DataDog/` instead of `https://`)
- `etc/config.yaml` — Devserver workspace config (shell, region, VS Code extensions)
- `etc/workspace-template.code-workspace` — VS Code multi-root workspace template targeting dd-source with Ruff/Python formatting

## Architecture

The `install.sh` script is the entry point. It uses `find` to locate all dotfiles in the repo root and symlinks them to equivalent paths under `$HOME`. This means any file starting with `.` added to the repo root will be automatically deployed.

The `etc/` directory holds non-dotfile configuration that isn't symlinked automatically — workspace and editor templates.

## tmux Usage

When working on tasks, decide whether to use tmux based on the task characteristics:

### Use tmux when:
- Task will take >5 minutes to complete
- Working with long-running processes (builds, tests, migrations, multi-ticket work)
- Using Claude Code agents (orchestrator, planner, ticket-worker)
- Want to preserve session across disconnections
- May need to step away mid-task

### Start tmux session:
```bash
# Check if already in tmux
if [ -z "$TMUX" ]; then
  # Create or attach to session
  tmux new -s work || tmux attach -s work
fi
```

### Skip tmux when:
- Quick questions or one-off commands
- Tasks taking <5 minutes
- Already in an interactive session you want to preserve

## Workflow

Whenever files in this repo are added, removed, or modified, update this CLAUDE.md to reflect the changes (add/remove/update entries in Key Files, Architecture, etc.). Keep CLAUDE.md as the single source of truth for what's in the repo.
