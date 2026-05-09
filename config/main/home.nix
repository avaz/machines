{ username, ... }:

# Machine-specific home-manager additions for "main".
# Base user/home-manager/sops wiring comes from common modules.
{
  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Machine-specific packages (on top of common ones in common/home.nix)
    ];
  };
}
