# MacBook Setup

Automated, convergent macOS workstation setup powered by Ansible, Homebrew Bundle, `uv`, and a zero-symlink Git Bare Repository for dotfiles.

## Architecture & Principles
- **Unified Python 3.15 Runtime via `uv`**: Both the Ansible controller virtual environment (`.venv`) and global Python CLI utilities (`pre-commit`, `yamllint`, `ansible-core`, `ansible-lint`) run on Python `3.15` managed by `uv`.
- **Single-Owner Package Management**: System formulae, GUI casks, VS Code extensions, and Go tools are declared in `Brewfile`; Python CLI tools are owned exclusively by `uv`.
- **Zero-Symlink Dotfiles**: Dotfiles are managed via a Git Bare Repository at `~/.dotfiles.git` with `$HOME` as the working tree (`alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'`).
- **Concept-Isolated Roles**: Six roles with explicit `meta/argument_specs.yml` contracts:
  - `homebrew`: Homebrew Bundle convergence and package upgrades
  - `dotfiles`: Git bare repository dotfile synchronization into `$HOME`
  - `clone_repos`: Workspace repository cloning (`~/Documents/Personal`, `~/Documents/Work`)
  - `wallpapers`: Cloudflare R2 wallpaper synchronization (`~/Documents/Wallpapers`)
  - `cli_tools`: Python `3.15` runtime, global `uv` CLI tools, and Oh My Zsh plugins
  - `osx_settings`: Declarative `osx_defaults` and default browser configuration

---

## One-Time Prerequisites (Fresh MacBook)
1. **Apple Command Line Tools**:
   ```bash
   xcode-select --install
   ```
2. **GitHub CLI Authentication** (required for cloning private workspace repositories):
   ```bash
   gh auth login
   ```
3. **Ansible Vault Secret** (required for Cloudflare R2 wallpaper synchronization).

---

## Bootstrap & Execution

### Full Workstation Bootstrap
Clone this repository and execute `bootstrap.sh`:
```bash
git clone https://github.com/BradleyYeo/MBP_setup.git
cd MBP_setup
./bootstrap.sh
```

`bootstrap.sh` performs the following steps:
- Installs Homebrew if not already present on `/opt/homebrew/bin/brew` or `/usr/local/bin/brew`.
- Installs `uv` via Homebrew.
- Upgrades and locks controller dependencies on Python `3.15` (`uv lock --upgrade && uv sync --locked`).
- Installs and upgrades required Ansible Galaxy collections (`uv run --locked ansible-galaxy install -r requirements.yml --force`).
- Runs the playbook (`uv run --locked ansible-playbook main.yml --ask-become-pass "$@"`).

### Day-to-Day Operations
- Run the full playbook:
  ```bash
  uv run --locked ansible-playbook main.yml
  ```
- Run a dry-run preview (`--check --diff`):
  ```bash
  uv run --locked ansible-playbook main.yml --check --diff
  ```
- Converge a single role by tag (`homebrew`, `dotfiles`, `repos`, `wallpapers`, `cli_tools`, `osx_settings`):
  ```bash
  uv run --locked ansible-playbook main.yml --tags dotfiles,cli_tools
  ```
- Check dotfile status via the bare repository alias:
  ```bash
  dotfiles status
  ```
- Lint all playbooks and roles under the `production` profile:
  ```bash
  uv run --locked ansible-lint --profile production
  ```
