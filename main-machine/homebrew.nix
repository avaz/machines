{ config, pkgs, ... }:

{
  imports = [
    ../common/homebrew.nix
  ];

  homebrew = {
    # Machine-specific additions/overrides
    casks = [
      "docker-desktop"
      "jetbrains-toolbox"
      "google-chrome"
      "shottr"
    ];

    masApps = {
      "Curve" = 1219074514;
      "Developer" = 640199958;
      "Linearity Move" = 6443677011;
      "Motion" = 434290957;
      "Photomator" = 1444636541;
      "Pixelmator Pro" = 1289583905;
      "Reeder" = 1529448980;
      "Xcode" = 497799835;
    };
  };
}
