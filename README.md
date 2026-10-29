# MacBook Setup

This repository provides an automated, idempotent setup pipeline for a macOS system leveraging Ansible to drive configuration, dotfile management, and system dependencies.

## Architecture & Principles
Designed following core system architecture principles:
- **Isolated Environments**: Uses `uv` to manage standalone Python binaries, virtual environments, and controller dependencies (`pyproject.toml`, `uv.lock`) in local `.venv` rather than mutating system Python or Homebrew's global Python packages.
- **Deterministic Layout**: Relies on a `Brewfile` processed via `brew bundle` for system CLI packages, casks, fonts, and developer tools.
- **Decoupled Settings**: MacOS UI preferences (`osx_defaults`) are managed independently from application binaries.

## Prerequisites
- A fresh or existing macOS system.
- Apple Command Line Tools (`xcode-select --install`).
- An existing `~/dotfiles` repository (optional, but recommended if linking dotfiles).

## Features
- Automated Homebrew tooling and bundle installation
- Python runtime and dependency isolation via `uv`
- Ansible-managed symlinks connecting your GitHub dotfiles to `$HOME`
- Strict `.gitignore` safeguarding local secrets
- Structured roles covering Homebrew, dotfiles, repository workspaces, CLI tools, and macOS system preferences

---

## Setup Instructions

### Pre-Flight Backup (Optional)
If you already have existing configs (such as `.zshrc`, `.aerospace.toml`) initialized in `$HOME` that you want to preserve before linking:
```bash
./backup_dotfiles.sh
```

### Initialize the Bootstrap
On the target machine, clone and execute the bootstrap script:
```bash
git clone https://github.com/BradleyYeo/MBP_setup.git
cd MBP_setup
./bootstrap.sh
```

`bootstrap.sh` acts as the minimal environment builder. It will:
- Install Homebrew if not already installed.
- Install `uv` via Homebrew.
- Provision the Python version specified in `.python-version` and sync dependencies via `uv sync --locked`.
- Install Ansible collections via `uv run --locked ansible-galaxy install -r requirements.yml`.
- Execute the playbook via `uv run --locked ansible-playbook main.yml --ask-become-pass "$@"`.

### Day-to-Day Operations
Run Ansible tasks or quality checks using `uv run`:
- Run the full playbook:
  ```bash
  uv run ansible-playbook main.yml --ask-become-pass
  ```
- Run dry-run check mode:
  ```bash
  uv run ansible-playbook main.yml --check --diff
  ```
- Run a specific role:
  ```bash
  uv run ansible-playbook main.yml --tags homebrew
  ```
- Lint playbooks and roles:
  ```bash
  uv run ansible-lint
  ```

### Verify Configurations
Once Ansible completes its run:
- Open a new terminal to source updated environment variables and shell configurations.
- Verify that command-line tools installed via Homebrew (`brew`, `git`, `uv`, etc.) operate successfully.
- Verify symlinks in `$HOME` (such as `~/.zshrc`, `~/.aerospace.toml`) point to `~/dotfiles`.

