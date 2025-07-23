{ config, pkgs, username, ... }:

{
  nix.enable = false;
  nix.package = pkgs.nix;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  environment.systemPackages = with pkgs; [
    git
    vim
    httpie
    curl
    jq
  ];

  system = {
    primaryUser = "${username}";
    stateVersion = 4;
    defaults = {
        dock = {
            autohide = true;
            launchanim = true;
            mouse-over-hilite-stack = true;
            orientation = "bottom";
            tilesize = 48;
        };
        trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
        };
        universalaccess = {
            reduceMotion = true;
            reduceTransparency = true;
        };
    };
    keyboard = {
        "enableKeyMapping" = true;
        "remapCapsLockToEscape" = true;
    };
  };
}
