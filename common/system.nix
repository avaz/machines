{ config, pkgs, username, ... }:

{
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 4;
  system.primaryUser = username;

  # Explicitly declare universalaccess defaults to prevent nix-darwin from
  # failing when it tries to write com.apple.universalaccess without permission.
  # These are the macOS defaults (no accessibility features enabled).
  system.defaults.universalaccess = {
    reduceMotion = false;
    reduceTransparency = false;
  };

  # Add other common system settings here
  # These will be inherited by all machines unless overridden
}
