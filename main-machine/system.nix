{ config, pkgs, username, ... }:

{
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
            reduceMotion = false;
            reduceTransparency = false;
        };
    };
    keyboard = {
        "enableKeyMapping" = true;
        "remapCapsLockToEscape" = true;
    };
  };
}
