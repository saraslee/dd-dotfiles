#!/usr/bin/env bash
# ensure you set the executable bit on the file with `chmod u+x install.sh`

# If you remove the .example extension from the file, once your workspace is created and the contents of this
# repo are copied into it, this script will execute.  This will happen in place of the default behavior of the workspace system,
# which is to symlink the dotfiles copied from this repo to the home directory in the workspace.
#
# Why would one use this file in stead of relying upon the default behavior?
#
# Using this file gives you a bit more control over what happens.
# If you want to do something complex in your workspace setup, you can do that here.
# Also, you can use this file to automatically install a certain tool in your workspace, such as vim.
#
# Just in case you still want the default behavior of symlinking the dotfiles to the root,
# we've included a block of code below for your convenience that does just that.

set -euo pipefail

DOTFILES_PATH="$HOME/dotfiles"

# Symlink dotfiles to the root within your workspace
find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" |
while read df; do
  link=${df/$DOTFILES_PATH/$HOME}
  mkdir -p "$(dirname "$link")"
  ln -sf "$df" "$link"
done

# Install zshmarks
echo "Installing zshmarks..."
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zshmarks" ]; then
  git clone https://github.com/jocelynmallon/zshmarks.git "$HOME/.oh-my-zsh/custom/plugins/zshmarks"
  echo "zshmarks installed successfully"
else
  echo "zshmarks already installed"
fi

# Install Graphite CLI
echo "Installing Graphite CLI..."
if ! command -v gt &>/dev/null; then
  if ! command -v npm &>/dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"
  npm install -g @withgraphite/graphite-cli@stable
  echo "export PATH=\"\$HOME/.npm-global/bin:\$PATH\"" >> "$HOME/.zshrc"
  echo "Graphite installed successfully"
else
  echo "Graphite already installed"
fi

# Install grpcurl
echo "Installing grpcurl..."
if ! command -v grpcurl &>/dev/null; then
  go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
  echo "grpcurl installed successfully"
else
  echo "grpcurl already installed"
fi

# Set up rapid symlink
echo "Setting up rapid symlink..."
mkdir -p "$HOME/.local/bin"
RAPID_SRC="/home/bits/dd/dd-source/domains/api_platform/rapid/apps/rapid/bin/rapid2-bzl"
RAPID_LINK="$HOME/.local/bin/rapid"
if [ -f "$RAPID_SRC" ] && [ ! -L "$RAPID_LINK" ]; then
  ln -s "$RAPID_SRC" "$RAPID_LINK"
  echo "rapid symlink created"
else
  echo "rapid symlink skipped (source not found or link already exists)"
fi

# Bootstrap dd-source
echo "Bootstrapping dd-source..."
DD_SOURCE="$HOME/dd/dd-source"
if [ -d "$DD_SOURCE" ]; then
  git -C "$DD_SOURCE" fetch && git -C "$DD_SOURCE" checkout main && git -C "$DD_SOURCE" pull
  COMPOSE_SRC="$DD_SOURCE/domains/devex/workspaces/apps/shell-image/etc/container-config/compose.yaml"
  COMPOSE_DEST="$HOME/go/src/github.com/DataDog/compose.yaml"
  if [ -f "$COMPOSE_SRC" ]; then
    cp "$COMPOSE_SRC" "$COMPOSE_DEST"
    echo "compose.yaml copied"
  fi
else
  echo "dd-source not found, skipping bootstrap"
fi
