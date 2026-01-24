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
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    users.${username} = { pkgs, config, lib, ... }: {
        imports = [
            ../common/home.nix
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