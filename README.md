# MacBook Setup

This repository provides an automated, idempotent setup string for a brand new MacBook leveraging Ansible to drive configuration, dotfile management, and system dependencies.

## Architecture & Principles
Designed following core system architecture principles:
1. **Isolated Environments**: Uses `pyenv` and `pip` locally within a managed bash script rather than global system Python or Homebrew's shifting Python environment, protecting Ansible from arbitrary dependency shifts.
2. **Deterministic Layout**: Relies on a `Brewfile` fed synchronously into the `community.general.homebrew_bundle` module.
3. **Decoupled Settings**: MacOS UI domain (`osx_defaults`) handles settings cleanly decoupled from the actual application binaries.

## Prerequisites
- A fresh MacOS system.
- An existing backup or structure of `$HOME/repositories/dotfiles` if using the dotfiles linking (optional, but recommended).

## Features
- Complete Xcode and Hombrew Tooling installation
- Fully automated `Brewfile` caching and processing for applications
- Ansible-managed symlinks binding your Github dotfiles to your `$HOME`
- Strict `.gitignore` configurations safeguarding local secrets (like `.gemini/` sessions)
- Headless installation of Google Gemini CLI and OpenAI CLI wrappers

---

## Setup Instructions

### 1. Pre-Flight Backup (If running on current machine)
If you already have existing configs (like `.zshrc`, `.aerospace.toml`) initialized that you want to preserve *before* tearing down or refreshing:
```bash
# This copies tracked items into ~/repositories/dotfiles, ready for a git push
./backup_dotfiles.sh
```

### 2. Initialize the Bootstrap
On the target machine, clone and execute the bootstrap script. 

`bootstrap.sh` acts as the Minimal Viable Environment builder. It will:
- Check for and install `brew`.
- Install `pyenv` via Homebrew.
- Bind Pyenv to Python `3.12.0` establishing an isolated Ansible runner.
- Execute `ansible-playbook main.yml`.

Launch the pipeline:
```bash
git clone https://github.com/BradleyYeo/MBP_setup.git
cd MBP_setup
./bootstrap.sh
```

### 3. Verify Configurations
Once Ansible completes its run:
1. Open a new terminal to flush Pyenv/Homebrew paths.
2. Ensure your commands like `brew`, `gemini`, and `openai` operate successfully.
3. Ensure tools like Aerospace have properly synced their `~/.aerospace.toml`.
