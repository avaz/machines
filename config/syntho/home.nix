{ username, ... }:

# Machine-specific home-manager additions for "syntho".
# Base config (users, zsh, secrets structure, common packages) comes from
# common/darwin-home.nix → common/home.nix.
{
  home-manager.users.${username} = { ... }: {
    # Add syntho-specific home-manager settings here.
  };
}
