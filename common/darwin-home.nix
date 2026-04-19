{ config, pkgs, username, sops-nix, ... }:
# Common nix-darwin module that:
#   - Configures the primary user account
#   - Wires up home-manager with sops-nix and the shared home configuration
# Machine-specific home-manager additions (packages, git, etc.) can be layered
# on top via additional `home-manager.users.${username}` modules.
{
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    users.${username} = { ... }: {
      imports = [
        sops-nix.homeManagerModules.sops
        ./home.nix
      ];
    };
  };
}
