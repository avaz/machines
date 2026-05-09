{ config, lib, pkgs, username, basecampCliPkg ? null, ... }:

let
  terminalTheme = ./.terminal.terminal;
  themeName = ".JoeTerminal";
in
{
  imports = [
    ./zsh.nix
    ./secrets.nix
    ./git.nix
  ];

  home.username = username;
  home.stateVersion = lib.mkDefault "24.05";
  home.packages = (with pkgs; [
    # Common packages for all machines
    git
    vim
    httpie
    curl
    jq
    tor
    direnv
    gh
    git-town
    htop
    docker-credential-helpers
    sops
    age
    ssh-to-age
    github-copilot-cli
  ]) ++ lib.optionals (basecampCliPkg != null) [
    basecampCliPkg
  ];

  # Import and set the macOS Terminal theme on activation.
  # The profile is read from the nix store; the script:
  #   1. Opens the .terminal file (registers it with Terminal.app)
  #   2. Writes it as the default and startup-window profile via `defaults`
  home.activation.importTerminalTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    THEME_SRC="${terminalTheme}"
    THEME_NAME="${themeName}"
    PREF_DOMAIN="com.apple.Terminal"

    # Check if the theme is already set as the default
    CURRENT_SETTING=$(/usr/bin/defaults read "$PREF_DOMAIN" "Default Window Settings" 2>/dev/null)

    if [ "$CURRENT_SETTING" != "$THEME_NAME" ]; then
      echo "Setting up Terminal theme '$THEME_NAME'..."
      /usr/bin/open "$THEME_SRC"
      # Give Terminal a moment to register the new profile
      /bin/sleep 1

      # Set as default and startup window profile
      /usr/bin/defaults write "$PREF_DOMAIN" "Default Window Settings" -string "$THEME_NAME"
      /usr/bin/defaults write "$PREF_DOMAIN" "Startup Window Settings" -string "$THEME_NAME"
      echo "Theme registered and set as default"
    else
      echo "Terminal theme already configured, skipping..."
    fi
  '';

  # Add other common programs/settings here
  # These will be inherited by all machines unless overridden
}
