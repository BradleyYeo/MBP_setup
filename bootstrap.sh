#!/bin/bash
# Bootstrap script for brand new MacBook setup
# Goal: Provide Environment for Ansible playbook to automatically setup macbook

set -euo pipefail

echo "Starting Minimal Bootstrap..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. Initialize Homebrew on PATH if already installed
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install Homebrew only if missing on disk and PATH
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew (and Apple Command Line Tools)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi


# 2. Install uv -> Python -> Virtualenv + Ansible dependencies
if ! command -v uv &>/dev/null; then
  echo "Installing uv via Homebrew..."
  brew install uv
fi

echo "Syncing Python $(tr -d '[:space:]' < .python-version) and controller dependencies via uv..."
uv sync --locked

# 3. Install required Ansible roles and collections
echo "Installing Ansible requirements..."
uv run --locked ansible-galaxy install -r requirements.yml

# 4. Run the Ansible playbook
echo "Running the Ansible playbook..."
uv run --locked ansible-playbook main.yml --ask-become-pass "$@"

echo "Setup complete!"
