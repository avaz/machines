{ config, pkgs, username, ... }:

{
  security = {
    pam = {
        services = {
            sudo_local = {
                touchIdAuth = true;
                watchIdAuth = false;
            };
        };
    };
  };

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
