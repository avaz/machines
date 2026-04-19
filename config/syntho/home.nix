{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}

