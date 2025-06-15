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
      home = {
        packages = with pkgs; [
          htop
          git-town
          gh
          docker-credential-helpers
          oh-my-zsh
        ];
        sessionVariables = {
          NIX_SHELL_PYTHON = "nix develop github:avaz/machines#python";
          NIX_SHELL_JAVA = "nix develop github:avaz/machines#java";
        };
        stateVersion = "23.11";
      };
    };
  };
}
