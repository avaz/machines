{ config, pkgs, username, ... }:

{
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";
  nix.package = pkgs.nix;
  system.stateVersion = 4;
  system.primaryUser = username;
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Add other common system settings here
  # These will be inherited by all machines unless overridden
}
