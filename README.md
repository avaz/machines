# Nix based machines configuration

This repository contains nix based files that configures the machines I own 
and use everyday. Essentially they are my `dotfiles` with steroids.

## Machines

- main-machine: my everyday use machine
- serveer-machine: an old MacBook that servers as mini-k8s server for testing and learning purposes

## How to use

To configure and reconfgure any machine run:

````shell
nix run nix-darwin -- switch --flake ~/.config/machines#main-machine
```

### Templates

This brings a few shell templates to allow for custom and clean development. 
To start a shell using one of the provided templates run:

```shell
nix flake init -t  ~/.config/machines#node-dev
```

### Shells

Also is provide some shells. To make use run:

````shell
nix develop ~/.config/machines#node -c $SHELL
```


