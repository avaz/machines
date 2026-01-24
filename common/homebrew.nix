{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "homebrew/cask"
    ];

    brews = [
    ];

    casks = [
    ];

    masApps = {
    };
  };
}
