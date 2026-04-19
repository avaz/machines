{ config, pkgs, username, ... }:

# Machine-specific home-manager additions for "main".
# The base user account, home-manager wiring, zsh, and common secrets
# are provided by common/darwin-home.nix → common/home.nix.
{
  home-manager.users.${username} = { pkgs, config, lib, ... }: {
    imports = [
      ./git.nix
    ];

    # Set the secrets file for this machine
    sops.defaultSopsFile = ./secrets.yaml;

    home.packages = with pkgs; [
      # Machine-specific packages (on top of common ones in common/home.nix)
    ];
  };
}
