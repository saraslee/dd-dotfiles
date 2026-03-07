# Sara Lee's Dotfiles

Personal dotfiles for Datadog workspaces. Cloned automatically during workspace creation via the `--dotfiles` flag.

## New Workspace Setup

### Prerequisites (one-time, on laptop)

1. **Appgate** — must be running and connected
2. **GitHub auth** — `ddtool auth github login`
3. **workspaces CLI** — `brew update && brew upgrade datadog-workspaces`
4. **GITLAB_TOKEN secret**:
   ```bash
   workspaces secrets set GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w) --export
   ```
5. **`~/.config/datadog/workspaces/config.yaml`** — must exist. Copy from this repo:
   ```bash
   mkdir -p ~/.config/datadog/workspaces
   cp etc/config.yaml ~/.config/datadog/workspaces/config.yaml
   cp etc/workspace-template.code-workspace ~/.config/datadog/workspaces/workspace-template.code-workspace
   ```

### Create the workspace

```bash
workspaces create <firstname-lastname> --repo dd-source
```

All flags (dotfiles, region, shell, vscode-template, extensions) are read from `config.yaml` automatically.

### Post-install (inside workspace)

SSH in and run the Claude Code agents setup (requires private repo access — can't run during dotfiles install):

```bash
ssh workspace-<name>
bash ~/dotfiles/setup-agents.sh
```

### Connect your IDE

```bash
workspaces connect <name> --editor vscode
```

Opens VS Code with dd-source, dogweb, consul-config, winter, k8s-resources.

---

## What's in here

| File | Purpose |
|------|---------|
| `install.sh` | Runs during workspace creation: symlinks dotfiles, installs tools (Graphite, grpcurl, rapid, zshmarks), bootstraps dd-source |
| `setup-agents.sh` | Run manually post-creation: clones experimental repo and sets up Claude Code config |
| `.zshrc` | Shell config: oh-my-zsh, direnv, GOPATH, dogweb.shellrc |
| `.my-aliases` | Aliases: rapid, kubectl, py3test, Claude |
| `.gitconfig` | Git config |
| `etc/config.yaml` | Workspaces CLI defaults (copy to `~/.config/datadog/workspaces/config.yaml` on laptop) |
| `etc/workspace-template.code-workspace` | VS Code multi-repo workspace template |

## Workspace Lifecycle

- Garbage collected after **20 days** of inactivity
- Max TTL of **6 months**
- SDM Bot will notify you in Slack before deletion
