{ config, ... }:

# Common sops/secrets configuration shared across all machines.
# Each machine must set `sops.defaultSopsFile` pointing to its own encrypted secrets.yaml.
# Example (in a machine-specific home module):
#   sops.defaultSopsFile = ./secrets.yaml;
{
  sops = {
    # Age key file location (consistent across machines)
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Common secrets extracted from the machine-specific secrets.yaml
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

