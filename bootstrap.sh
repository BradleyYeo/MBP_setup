#!/bin/bash
# Bootstrap script for brand new MacBook setup
# Goal: Provide Minimal Viable Environment (MVE) for Ansible

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


# 2. Install Pyenv -> Python -> Ansible
if ! command -v pyenv &>/dev/null; then
  echo "Installing pyenv via Homebrew..."
  brew install pyenv
fi

# Configure pyenv for the current script session
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

PYTHON_VERSION=$(cat .python-version | tr -d '[:space:]')
if ! pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
  echo "Installing Python ${PYTHON_VERSION} via pyenv..."
  pyenv install "${PYTHON_VERSION}"
fi
# Create local virtualenv if missing
if [ ! -d ".venv" ]; then
  echo "Creating virtual environment in .venv..."
  "$(pyenv prefix "${PYTHON_VERSION}")/bin/python" -m venv .venv
fi
# Install controller dependencies
echo "Installing controller dependencies from requirements.txt..."
.venv/bin/python -m pip install --upgrade pip
.venv/bin/pip install -r requirements.txt
# 3. Install required Ansible roles and collections
echo "Installing Ansible requirements..."
.venv/bin/ansible-galaxy install -r requirements.yml
# 4. Run the Ansible playbook
echo "Running the Ansible playbook..."
.venv/bin/ansible-playbook main.yml --ask-become-pass "$@"


echo "Setup complete!"
