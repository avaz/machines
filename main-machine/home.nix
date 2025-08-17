{ config, pkgs, username, ... }:

{
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${username} = { pkgs, config, lib, ... }: {
        imports = [
            ./zsh.nix
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