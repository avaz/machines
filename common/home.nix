{ config, pkgs, username, ... }:

{
  home.username = username;
  home.stateVersion = "23.11";

  # Add other common programs/settings here
  # These will be inherited by all machines unless overridden
}
