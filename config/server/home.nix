{ username, ... }:

# Machine-specific home-manager additions for "server".
# Base config (users, zsh, secrets structure, common packages) comes from
# common/darwin-home.nix → common/home.nix.
{
  home-manager.users.${username} = { ... }: {
    home.stateVersion = "23.11";

    home.packages = [];  # Add server-specific packages here
  };
}
