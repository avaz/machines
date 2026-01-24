{ config, pkgs, username, ... }:

{
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 4;
  system.primaryUser = username;

  # Add other common system settings here
  # These will be inherited by all machines unless overridden
}
