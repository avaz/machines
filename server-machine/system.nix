{ config, pkgs, ... }:

{
  nix.enable = false;
  nix.package = pkgs.nix;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  environment.systemPackages = with pkgs; [
    git
    vim
    httpie
    curl
    jq
    socat
    colima
    docker
    kubectl
    lima
  ];

  launchd.daemons.socat-k8s = {
    serviceConfig = {
      Label = "com.avaz.socat-k8s";
      ProgramArguments = [
        "${pkgs.socat}/bin/socat"
        "TCP-LISTEN:6443,reuseaddr,fork,bind=0.0.0.0"
        "TCP:127.0.0.1:49329"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/socat-k8s.out";
      StandardErrorPath = "/var/log/socat-k8s.err";
    };
  };
  launchd.user.agents.colima = {
    serviceConfig = {
      Label = "com.avaz.colima";
      ProgramArguments = [
        "/bin/zsh"
        "-c"
        "${pkgs.colima}/bin/colima start --foreground -k"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = "/Users/anderson";
      StandardOutPath = "/Users/anderson/Library/Logs/colima.log";
      StandardErrorPath = "/Users/anderson/Library/Logs/colima.err";
    };
  };
  system = {
    stateVersion = 4;
    defaults = {
      dock = {
        autohide = true;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
