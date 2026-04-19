{
  description = "Machines configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
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
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, homebrew-core, homebrew-cask, sops-nix, ... }:
  let
    systems = {
      mac-arm = "aarch64-darwin";
      mac-x86 = "x86_64-darwin";
    };

    machines = [
      "main"
      "server"
      "syntho"
    ];

    username = nixpkgs.lib.defaultTo (builtins.getEnv "USER") "anderson";

    mkDarwinConfig = name:
      let
        machine = import ./config/${name}/default.nix {
          inherit systems username home-manager nix-homebrew homebrew-core homebrew-cask;
        };
      in
      nix-darwin.lib.darwinSystem {
        inherit (machine) system;
        modules = machine.modules;
        specialArgs = {
          inherit username sops-nix homebrew-core homebrew-cask;
        } // (machine.specialArgs or { });
      };
  in
  {
    darwinConfigurations = nixpkgs.lib.genAttrs machines mkDarwinConfig;

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
