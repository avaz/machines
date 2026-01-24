{
  description = "Machines configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, ... }:
  let
    systems = {
      mac-arm = "aarch64-darwin";
      mac-x86 = "x86_64-darwin";
    };

    machines = {
      "main-machine" = { system = systems.mac-arm; path = "main-machine"; };
      "server-machine" = { system = systems.mac-x86; path = "server-machine"; };
    };

    username = nixpkgs.lib.defaultTo (builtins.getEnv "USER") "anderson";

    mkDarwinConfig = machine:
      let
          overlays = import ./${machine.path}/overlays.nix;
          pkgs = import nixpkgs {
            system = machine.system;
            inherit overlays;
          };
        in
      nix-darwin.lib.darwinSystem {
      inherit (machine) system;
      modules = [
        ./common/system.nix
        ./${machine.path}/system.nix
        home-manager.darwinModules.home-manager
        ./${machine.path}/home.nix
        ./${machine.path}/homebrew.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          networking.hostName = machine.path;
          nix-homebrew = {
            enable = true;
            enableRosetta = machine.system == systems.mac-arm;  # Only enable for ARM Macs
            user = username;  # Use the username variable
            autoMigrate = true;  # Automatically migrate existing Homebrew installations
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
          };
        }
      ];
      specialArgs = { inherit username; };
    };
  in
  {
    darwinConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames machines) (name:
      mkDarwinConfig machines.${name}
    );

    devShells = nixpkgs.lib.genAttrs (builtins.attrValues systems) (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        python = pkgs.mkShell { packages = [ pkgs.python3 pkgs.uv ]; };
        java = pkgs.mkShell { packages = [ pkgs.openjdk pkgs.maven pkgs.gradle ]; };
        node = pkgs.mkShell { packages = [ pkgs.nodejs pkgs.bun ]; };
      }
    );

    templates = {
      python = {
        path = ./templates/python;
        description = "Python development environment";
      };

      java = {
        path = ./templates/java;
        description = "Java development environment";
      };

      node = {
        path = ./templates/node;
        description = "NodeJS development environment";
      };
    };
  };
}
