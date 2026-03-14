# MacBook Setup (Ansible)

This repository automates the setup of a new MacBook using Ansible.

## Features
- Installs Xcode Command Line Tools
- Installs Homebrew and packages from `Brewfile`
- Clones and links dotfiles from a GitHub repository
- Configures macOS defaults

## Prerequisites
- A brand new MacBook (or an existing one you want to re-setup)
- Access to your dotfiles repository on GitHub

## Setup Instructions

1. **Clone this repository**:
   ```bash
   git clone https://github.com/BradleyYeo/MBP_setup.git
   cd MBP_setup
   ```

2. **(Optional) Backup dotfiles from your current laptop**:
   If you are on your current laptop and want to ensure your dotfiles are ready:
   ```bash
   ./backup_dotfiles.sh
   # Then push to your dotfiles repo
   ```

3. **Run the bootstrap script**:
   On your new MacBook, run:
   ```bash
   ./bootstrap.sh
   ```
   This script will install Homebrew, Ansible, and run the playbook.

## Project Structure
- `main.yml`: The entry point for Ansible.
- `Brewfile`: Lists all Homebrew packages and casks.
- `requirements.yml`: Lists external Ansible roles and collections.
- `roles/`: Contains modular tasks for Homebrew, dotfiles, and macOS settings.
- `vars/main.yml`: Configuration variables (e.g., dotfiles repo URL).
