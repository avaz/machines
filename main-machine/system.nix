{ config, pkgs, ... }:

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
    };
    keyboard = {
        "enableKeyMapping" = true;
        "remapCapsLockToEscape" = true;
    };
  };
}
