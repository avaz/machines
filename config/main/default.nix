{ systems, home-manager, nix-homebrew, ... }:
let
  system = systems.mac-arm;
  overlays = import ./overlays.nix;
in
{
  inherit system;

  modules = [
    {
      networking.hostName = "main";
      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfree = true;
    }
    ../../common/system.nix
    ../../common/darwin-home.nix
    ../../common/homebrew.nix
    ../../common/homebrew-system.nix
    ./system.nix
    home-manager.darwinModules.home-manager
    ./home.nix
    ./homebrew.nix
    nix-homebrew.darwinModules.nix-homebrew
  ];
}
