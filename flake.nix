{
  description = "Machines configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    systems = {
      mac-arm = "aarch64-darwin";
      mac-intel = "x86_64-darwin";
    };

    machines = {
      "main-machine" = { system = systems.mac-arm; path = "main-machine"; };
      "server-machine" = { system = systems.mac-intel; path = "server-machine"; };
    };

    username = nixpkgs.lib.defaultTo (builtins.getEnv "USER") "anderson";

    mkDarwinConfig = machine: nix-darwin.lib.darwinSystem {
      inherit (machine) system;
      modules = [
        ./${machine.path}/system.nix
        home-manager.darwinModules.home-manager
        ./${machine.path}/home.nix
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
      python-dev = {
        path = ./templates/python;
        description = "Python development environment template";
      };

      java-dev = {
        path = ./templates/java;
        description = "Java development environment template";
      };
    };
  };
}
