{ config, pkgs, ... }:

{
  imports = [
    ../common/homebrew.nix
  ];

  homebrew = {
    # Machine-specific additions/overrides
    brews = [
      # Server-specific packages
    ];

    casks = [
      # Server-specific casks
    ];
  };
}
