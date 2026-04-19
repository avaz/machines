{ config, lib, pkgs, username, ... }:

let
  terminalTheme = ./.terminal.terminal;
  themeName = ".JoeTerminal";
in
{
  imports = [
    ./zsh.nix
    ./secrets.nix
  ];

  home.username = username;
  home.stateVersion = lib.mkDefault "24.05";
  home.packages = with pkgs; [
    # Common packages for all machines
    tor
    direnv
    gh
    git-town
    htop
    docker-credential-helpers
    aws-vault
  ];

  # Import and set the macOS Terminal theme on activation.
  # The profile is read from the nix store; the script:
  #   1. Opens the .terminal file (registers it with Terminal.app)
  #   2. Writes it as the default and startup-window profile via `defaults`
  home.activation.importTerminalTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    THEME_SRC="${terminalTheme}"
    THEME_NAME="${themeName}"
    PREF_DOMAIN="com.apple.Terminal"

    # Only import if the profile isn't already registered
    if ! /usr/libexec/PlistBuddy -c "Print :'Window Settings':'$THEME_NAME'" \
        ~/Library/Preferences/$PREF_DOMAIN.plist &>/dev/null; then
      /usr/bin/open "$THEME_SRC"
      # Give Terminal a moment to register the new profile
      /bin/sleep 1
    fi

    # Set as default and startup window profile
    /usr/bin/defaults write "$PREF_DOMAIN" "Default Window Settings" -string "$THEME_NAME"
    /usr/bin/defaults write "$PREF_DOMAIN" "Startup Window Settings" -string "$THEME_NAME"
  '';

  # Add other common programs/settings here
  # These will be inherited by all machines unless overridden
}
