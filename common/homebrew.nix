{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/cask"
    ];

    # Baseline Homebrew packages for all machines.
    brews = [
      "mas"
    ];

    # Keep common casks conservative; machine modules can append more.
    casks = [
    ];

    masApps = {
    };
  };
}
