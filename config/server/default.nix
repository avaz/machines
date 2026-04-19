{ systems, home-manager, nix-homebrew, ... }:
let
  system = systems.mac-x86;
  overlays = import ./overlays.nix;
in
{
  inherit system;

  modules = [
    {
      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfree = true;
    }
    ../../common/system.nix
    ../../common/homebrew.nix
    ../../common/homebrew-system.nix
    ./system.nix
    home-manager.darwinModules.home-manager
    ../../common/darwin-home.nix
    ./home.nix
    ./homebrew.nix
    nix-homebrew.darwinModules.nix-homebrew
    {
      networking.hostName = "server";
    }
  ];
}



