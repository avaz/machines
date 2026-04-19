{ config, pkgs, username, ... }:

{
  home.username = username;
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    # Common packages for all machines
    tor
    direnv
    gh
    git-town
  ];

  # Add other common programs/settings here
  # These will be inherited by all machines unless overridden
}
