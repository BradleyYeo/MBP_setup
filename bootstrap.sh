#!/bin/bash
# Bootstrap script for brand new MacBook setup
# Goal: Provide Minimal Viable Environment (MVE) for Ansible

set -e

echo "Starting Minimal Bootstrap..."

# 1. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for the current shell session
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
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Dynamically get the latest stable Python 3 version
PYTHON_VERSION=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')

# Install the latest Python version and set it as global
if ! pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
  echo "Installing Python ${PYTHON_VERSION} via pyenv..."
  pyenv install "${PYTHON_VERSION}"
fi
pyenv global "${PYTHON_VERSION}"

# Install ansible via pip
echo "Installing Ansible (ansible, ansible-galaxy, ansible-playbook) via pip..."
python -m pip install --upgrade pip
python -m pip install ansible

# 3. Install required Ansible roles and collections
echo "Installing Ansible requirements..."
ansible-galaxy install -r requirements.yml
ansible-galaxy collection install -r requirements.yml

# 4. Run the Ansible playbook
echo "Running the Ansible playbook..."
ansible-playbook main.yml --ask-become-pass

echo "Setup complete!"
