{ systems, username, home-manager, nix-homebrew, homebrew-core, homebrew-cask, ... }:
let
  system = systems.mac-arm;
  overlays = import ./overlays.nix;
in
{
  inherit system;

  modules = [
    {
      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfree = true;
    }
    ../common/system.nix
    ./system.nix
    home-manager.darwinModules.home-manager
    ./home.nix
    ./homebrew.nix
    nix-homebrew.darwinModules.nix-homebrew
    {
      networking.hostName = "main-machine";
      nix-homebrew = {
        enable = true;
        enableRosetta = system == systems.mac-arm;
        user = username;
        autoMigrate = true;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
        };
        mutableTaps = false;
      };
    }
  ];
}

