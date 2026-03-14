# Software Design Feedback: MacBook Setup Playbook

## 1. Deep vs. Shallow Modules (Ousterhout)
- **Observation:** Using `ansible.builtin.shell` for `defaults write` created "shallow" tasks. These tasks required manual state management (`changed_when: false`) and exposed low-level implementation details.
- **Refinement:** Switched to `community.general.osx_defaults`. This creates a "deep" interface where the complexity of checking existing state and applying changes is hidden behind a declarative module.

## 2. Conceptual Integrity (Jackson)
- **Observation:** "Split Brain" between `bootstrap.sh` and Ansible roles. Both were attempting to manage the installation of Homebrew and Xcode CLT.
- **Refinement:** Redefined `bootstrap.sh` as a "Minimal Viable Environment" (MVE) provider. It now only ensures Homebrew and Ansible are present. All subsequent configuration (including CLT and Brewfile processing) is delegated to Ansible.

## 3. Information Hiding & State Transitions (Parnas)
- **Observation:** `SystemUIServer` was being restarted on every run, regardless of whether settings changed. This violated the principle of idempotency and leaked implementation details of the OS into every execution.
- **Refinement:** Implemented **Ansible Handlers**. The system now only restarts services if a task explicitly signals a state change (`notify`).

## 4. Separation of Concerns
- **Observation:** The `homebrew` role was doing manual path checking for Intel vs. Apple Silicon.
- **Refinement:** Relied on the `community.general.homebrew` module's ability to locate `brew` automatically when available in the PATH, reducing fragile hardcoded paths.

## 5. Principle of Least Power
- **Conclusion:** Validated the use of `Brewfile` for package management. While Ansible *can* manage individual packages, the `Brewfile` is a specialized, "less powerful" (and therefore more robust) tool for this specific domain.
