{ config, lib, ... }:

{
  system = {
    defaults = {
      # syntho inherits common/system.nix, but we explicitly disable universalaccess
      # writes since they fail due to TCC restrictions on this machine.
      # Since reduceMotion=false and reduceTransparency=false are already macOS defaults,
      # disabling this is safe (nothing is lost).
      universalaccess = lib.mkForce {};
      dock = {
        autohide = true;
      };
      NSGlobalDomain = {
        KeyRepeat = 15;
        InitialKeyRepeat = 15;
      };
    };
  };
}

