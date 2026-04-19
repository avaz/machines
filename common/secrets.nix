{ config, lib, machineDir, ... }:

let
  secretsFile = builtins.toPath "${machineDir}/secrets.yaml";
  hasSecretsFile = builtins.pathExists secretsFile;
in
# Common sops/secrets configuration shared across all machines.
# On first bootstrap, secrets.yaml may not exist yet; in that case we disable
# secret extraction so darwin-rebuild can run and install sops tooling.
{
  sops = {
    # Age key file location (consistent across machines)
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  } // lib.optionalAttrs hasSecretsFile {
    defaultSopsFile = secretsFile;

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
