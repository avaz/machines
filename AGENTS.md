# AGENTS Guide

## Big Picture
- This repo is a macOS fleet config built with `nix-darwin` + `home-manager` + `sops-nix` (see `flake.nix`, `common/darwin-home.nix`).
- `flake.nix` is the orchestration entrypoint: it defines machine names, calls `mkDarwinConfig`, and passes `specialArgs` like `machineName`, `machineDir`, and `basecampCliPkg`.
- Each machine in `config/<machine>/default.nix` composes modules in layers: shared `../../common/*.nix` first, then machine-specific `./system.nix`, `./home.nix`, `./homebrew.nix`.
- Shared behavior lives in `common/`; machine deltas are intentionally thin (example: `config/syntho/system.nix` only overrides problematic defaults).

## Where To Change What
- Cross-machine shell/packages/home-manager behavior: edit `common/home.nix` and `common/zsh.nix`.
- Cross-machine Darwin/system settings: edit `common/system.nix`.
- Cross-machine Homebrew policy (activation/update/cleanup): edit `common/homebrew.nix` and `common/homebrew-system.nix`.
- Machine-only changes: edit files under `config/<machine>/` (do not copy edits across machines unless needed).
- Git behavior is machine-local today (`config/main/git.nix`, `config/syntho/git.nix`), even though most logic is duplicated.

## Secrets + Data Flow
- Secrets are encrypted per machine in `config/<machine>/secrets.yaml`; encryption rules live in `.sops.yaml`.
- `common/secrets.nix` intentionally tolerates missing `secrets.yaml` so first bootstrap can run before secrets exist.
- Important flake-source gotcha: if `secrets.yaml` exists locally but is not tracked, `darwin-rebuild` may still warn/fail because Nix evaluates tracked source paths.
- Git identity flows from sops secrets (`git/user/name`, `git/user/email`) into generated files under `~/.config/git-secrets` or sops templates.

## Developer Workflows (project-specific)
- Preferred rebuild command is explicit machine targeting:
  - `sudo darwin-rebuild switch --flake ~/.config/machines#<machine>`
- First bootstrap when `darwin-rebuild` is unavailable (from `docs/commands.md`):
  - `sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/machines#<machine>`
- `apply` alias (`common/zsh.nix`) omits `#<machine>`; use explicit commands when debugging wrong-host applies.
- Validate the `universalaccess` issue using commands in `docs/commands.md`; `syntho` intentionally disables this domain in `config/syntho/system.nix`.
- Secrets editing must run from repo root (or pass `--config`) so `sops` can find `.sops.yaml` (`docs/sops.md`).

## Integrations and Patterns to Preserve
- Homebrew is managed declaratively via `nix-homebrew` with pinned taps and `mutableTaps = false` (`common/homebrew-system.nix`).
- Home-manager activation hooks are used for imperative macOS setup (Terminal theme import in `common/home.nix`, SSH/git signer setup in `config/*/git.nix`). Keep idempotency checks when adding hooks.
- `server` has launchd-managed infra (`config/server/system.nix`) for `socat` and `colima`; treat it as a service host, not a desktop-only profile.
- Dev shells/templates are exposed from `flake.nix` and `templates/*/flake.nix`; keep names (`python`, `java`, `node`) aligned between outputs and docs.

## Fast Validation Checklist
- Run target build before broad changes: `nix build ~/.config/machines#darwinConfigurations.<machine>.system --no-link`.
- Then apply: `sudo darwin-rebuild switch --flake ~/.config/machines#<machine>`.
- If touching secrets wiring, verify decrypt/edit flow from `docs/sops.md` without committing plaintext values.

