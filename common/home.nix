{ config, lib, pkgs, username, ... }:

{
  imports = [
    ./zsh.nix
    ./secrets.nix
  ];

  home.username = username;
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    # Common packages for all machines
    tor
    direnv
    gh
    git-town
    htop
    docker-credential-helpers
    aws-vault
  ];

  # Add other common programs/settings here
  # These will be inherited by all machines unless overridden
}
