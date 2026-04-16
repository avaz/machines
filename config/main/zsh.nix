{ pkgs, config, ... }:

let
  typewritten-theme = pkgs.stdenv.mkDerivation {
    name = "typewritten-theme";
    src = pkgs.fetchurl {
      url = "https://github.com/reobin/typewritten/archive/refs/tags/v1.5.2.tar.gz";
      sha256 = "1z9629vz8h7dfxdv1p29zc2zrlamhfp7ni9izb3ymjv6kqixip03";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out
      cp -r typewritten-*/* $out/
    '';
  };
  customDir = "${config.home.homeDirectory}/.config/.oh-my-zsh-custom";
in
{
  home = {
    file.".config/.oh-my-zsh-custom/themes/typewritten.zsh-theme".source = "${typewritten-theme}/typewritten.zsh-theme";
    file.".config/.oh-my-zsh-custom/themes/async.zsh".source = "${typewritten-theme}/async.zsh";
    file.".config/.oh-my-zsh-custom/themes/lib".source = "${typewritten-theme}/lib";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "gh"
        "history-substring-search"
        "gradle"
        "kubectl"
        "common-aliases"
      ];
      theme = "typewritten";
      custom = customDir;
    };

    shellAliases = {
      q = "exit";
#      apply = "sudo nix run nix-darwin -- switch --flake ~/.config/machines";
      apply = "sudo darwin-rebuild switch --flake ~/.config/machines#main";
      apply-update = "nix flake update --flake ~/.config/machines && sudo darwin-rebuild switch --flake ~/.config/machines#main";
      show = "nix flake show ~/.config/machines";
      config = "idea ~/.config/machines";
      gtts = "git town sync";
      prefetch = "nix flake prefetch $1";
      prefetch-url = "nix flake prefetch-url $1";
      shj = "nix develop github:avaz/machines#java -c $SHELL";
      shp = "nix develop github:avaz/machines#python -c $SHELL";
      shn = "nix develop github:avaz/machines#node -c $SHELL";
      pjj = "nix flake init -t github:avaz/machines#java";
      pjp = "nix flake init -t github:avaz/machines#python";
      pjn = "nix flake init -t github:avaz/machines#node";
    };

    # Custom shell initialization
    initContent = ''
        if [[ -n "$OMZ_PROJECT_PLUGINS" ]]; then
          plugins+=(''${=OMZ_PROJECT_PLUGINS})
        fi
    '';
  };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
}
