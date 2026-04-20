{ config, lib, machineDir ? null, machineName ? null, ... }:

let
  resolvedMachineDir =
    if machineDir != null then machineDir
    else if machineName != null then builtins.toPath "${./..}/config/${machineName}"
    else null;
  secretsFile =
    if resolvedMachineDir != null then builtins.toPath "${resolvedMachineDir}/secrets.yaml"
    else null;
  hasSecretsFile = secretsFile != null && builtins.pathExists secretsFile;
in
# Common sops/secrets configuration shared across all machines.
# On first bootstrap, secrets.yaml may not exist yet; in that case we disable
# secret extraction so darwin-rebuild can run and install sops tooling.
{
  warnings = lib.optional (!hasSecretsFile && machineName != null)
    "sops: ${machineName} secrets.yaml not found in flake source (${toString secretsFile}). If the file exists locally, run: git add config/${machineName}/secrets.yaml";

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
