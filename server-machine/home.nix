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
        stateVersion = "23.11";
        packages = with pkgs; [
          htop
          git-town
          gh
          docker-credential-helpers
        ];
      };
      
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "docker"
            "gh"
            "history-substring-search"
          ];
          theme = "typewritten";
          custom = "$HOME/.oh-my-zsh-custom";
        };
      };
    };
  };
}