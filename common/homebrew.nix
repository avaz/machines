{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
    };

    taps = [
      "homebrew/cask"
    ];

    brews = [
        "mas"
    ];

    casks = [
    ];

    masApps = {
    };
  };
}
