# Nix-based machines configuration

This repository contains nix-based files that configure the machines I own 
and use every day. Essentially they are my `dotfiles` with steroids.

## Machines

- main-machine: my everyday use machine
- server-machine: an old MacBook that servers as a mini-k8s server for testing and learning purposes

## How to use

To configure and reconfigure, any machine run:

```shell
apply
```

### Templates

This configuration brings a few shell templates to allow for custom and clean development.
To start a shell using one of the provided templates, run:

```shell
nix flake init -t  ~/.config/machines#python
```

### Shells

Also is providing some shells. To make use run:

```shell
nix develop ~/.config/machines#node -c $SHELL
```
