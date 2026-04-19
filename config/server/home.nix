{ username, ... }:

# Machine-specific home-manager additions for "server".
# Base config (users, zsh, secrets structure, common packages) comes from
# common/darwin-home.nix → common/home.nix.
{
  home-manager.users.${username} = { ... }: {
    # Point sops at this machine's encrypted secrets file.
    # Create it with: cd config/server && sops secrets.yaml
    sops.defaultSopsFile = ./secrets.yaml;

    home.stateVersion = "23.11";

    home.packages = [];  # Add server-specific packages here
  };
}
