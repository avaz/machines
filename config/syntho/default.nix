{ systems, home-manager, nix-homebrew, ... }:
let
  system = systems.mac-arm;
in
{
  inherit system;

  modules = [
    {
      nixpkgs.config.allowUnfree = true;
      networking.hostName = "syntho";
    }
    ../../common/system.nix
    ../../common/homebrew.nix
    ../../common/homebrew-system.nix
    nix-homebrew.darwinModules.nix-homebrew
    home-manager.darwinModules.home-manager
    ../../common/darwin-home.nix
    ./home.nix
    ./homebrew.nix
  ];
}
