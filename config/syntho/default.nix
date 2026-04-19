{ systems, username, home-manager, ... }:
let
  system = systems.mac-arm;
in
{
  inherit system;

  modules = [
    ../../common/system.nix
    {
      nixpkgs.config.allowUnfree = true;
    }
    home-manager.darwinModules.home-manager
    {
      networking.hostName = "syntho";
      home-manager.users.${username} = import ./home.nix;
    }
  ];
}

