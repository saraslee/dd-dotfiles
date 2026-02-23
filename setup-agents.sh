#!/usr/bin/env bash
# Clone the experimental repo and set up Claude Code agents.
# Run this manually after install.sh — it requires access to the private DataDog/experimental repo.

set -euo pipefail

EXPERIMENTAL_DIR="$HOME/dd/experimental"
echo "Setting up Claude Code agents from experimental repo..."
if [ ! -d "$EXPERIMENTAL_DIR" ]; then
  git clone git@github.com:DataDog/experimental.git "$EXPERIMENTAL_DIR"
  echo "Cloned experimental repo"
else
  echo "experimental repo already cloned"
fi
bash "$EXPERIMENTAL_DIR/users/sara.lee/scripts/install.sh"
