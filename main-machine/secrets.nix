{ config, pkgs, username, ... }:

{
  sops = {
    # Age key file location
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Default sops file
    defaultSopsFile = ./secrets.yaml;

    # Secrets to be extracted
    secrets = {
      "git/user/name" = {
        path = "${config.home.homeDirectory}/.config/git-secrets/name";
      };
      "git/user/email" = {
        path = "${config.home.homeDirectory}/.config/git-secrets/email";
      };
    };
  };
}

