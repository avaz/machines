{ username, ... }:

# Machine-specific home-manager additions for "syntho".
# Base config (users, zsh, secrets structure, common packages) comes from
# common/darwin-home.nix → common/home.nix.
{
  home-manager.users.${username} = { ... }: {
    # Point sops at this machine's encrypted secrets file.
    # Create it with: cd config/syntho && sops secrets.yaml
    sops.defaultSopsFile = ./secrets.yaml;

    home.stateVersion = "24.05";
  };
}

