{ config, lib, ... }:

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
        NSGlobalDomain = {
          KeyRepeat = 1;
          InitialKeyRepeat = 10;
        };
    };
    keyboard = {
        "enableKeyMapping" = true;
        "remapCapsLockToEscape" = true;
    };
  };
}

