{ pkgs, ... }:

let
  typewritten-theme = fetchTarball {
    url = "https://github.com/reobin/typewritten/archive/refs/tags/v1.5.2.tar.gz";
    sha256 = "09y419rcylm5l6qy8pjj90zk4lx8b1vanbkdi7wcl03wngndwwv4";
  };
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
        "direnv"
        "gh"
        "history-substring-search"
      ];
      theme = "typewritten";
      custom = "$HOME/.config/.oh-my-zsh-custom";
    };

    shellAliases = {
      ll = "ls -l";
      l = "ls -la";
      q = "exit";
      k = "kubectl";
      shj = "nix develop github:avaz/machines#java -c $SHELL";
      shp = "nix develop github:avaz/machines#python -c $SHELL";
      shn = "nix develop github:avaz/machines#node -c $SHELL";
      pjv = "nix flake init -t github:avaz/machines#java";
      ppt = "nix flake init -t github:avaz/machines#python";
      pno = "nix flake init -t github:avaz/machines#node";
    };

    # Custom shell initialization
    initContent = ''
      # Add any custom zsh configuration here
    '';
  };
}