# Nix-based machines configuration

This repository contains the nix-darwin + home-manager setup for my macOS machines.

## Machines

- `main`: everyday machine
- `server`: old MacBook used as a mini-k8s server
- `syntho`: personal/workstation machine

## Fresh setup on a new macOS machine

1. Install Nix (Determinate Nix or official Nix installer).
2. Clone this repository to `~/.config/machines`.
3. Run the first switch using the target machine name.
4. Bootstrap secrets (see `docs/sops.md`).
5. Run switch again.

Use `<machine>` as one of `main`, `server`, or `syntho` or leave it blank and the OS machine name will be used:

```shell
sudo nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin/master#darwin-rebuild -- \
  switch --flake ~/.config/machines
```

After `darwin-rebuild` is available, you can use:

```shell
sudo darwin-rebuild switch --flake ~/.config/machines
```

## Rebuild workflow

- Explicit command (recommended):

  ```shell
  sudo darwin-rebuild switch --flake ~/.config/machines
  ```

- Alias `apply` exists in zsh config.

## Secrets bootstrap

Follow `docs/sops.md` for first bootstrapping and ongoing secret management.

## Terminal theme auto-import

The file `common/.terminal.terminal` is automatically imported during Home Manager activation.

- profile name: `.JoeTerminal`
- set as both startup and default Terminal profile
- the first activation may open Terminal.app briefly to register the profile

## Troubleshooting

### `Could not write domain com.apple.universalaccess`

If you see this on a host, check whether that machine enables
`system.defaults.universalaccess`. On `syntho`, this is intentionally disabled via
`config/syntho/system.nix` because this domain can be blocked by macOS permissions.

### `apply` updates the wrong machine

Use the explicit machine command instead of `apply`:

```shell
sudo darwin-rebuild switch --flake ~/.config/machines
```

## Templates

Create a project from a template:

```shell
nix flake init -t ~/.config/machines#python
```

## Dev shells

Start a shell from this flake:

```shell
nix develop ~/.config/machines#node -c $SHELL
```
