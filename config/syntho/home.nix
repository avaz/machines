{ username, pkgs, ... }:

# Machine-specific home-manager additions for "syntho".
# Base config (users, zsh, secrets structure, common packages) comes from
# common/darwin-home.nix → common/home.nix.
{
  home-manager.users.${username} = { ... }: {
    # Add syntho-specific home-manager settings here.
    imports = [
      ./git.nix
    ];

    home.packages = with pkgs; [
      # Machine-specific packages (on top of common ones in common/home.nix)
      awscli2
      aws-vault
    ];
  };
}
