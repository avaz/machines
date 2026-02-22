{ config, pkgs, username, sops-nix, ... }:

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
    users.${username} = { pkgs, config, lib, ... }: {
        imports = [
            sops-nix.homeManagerModules.sops
            ../common/home.nix
            ./zsh.nix
            ./git.nix
            ./secrets.nix
        ];
        home = {
            stateVersion = "23.11";
            packages = with pkgs; [
                htop
                git-town
                gh
                tor
                direnv
                docker-credential-helpers
                aws-vault
            ];
        };
    };
  };
}