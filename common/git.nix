{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      alias = {
        append = "town append";
        compress = "town compress";
        continue = "town continue";
        contribute = "town contribute";
        delete = "town delete";
        "diff-parent" = "town diff-parent";
        down = "town down";
        hack = "town hack";
        observe = "town observe";
        park = "town park";
        prepend = "town prepend";
        propose = "town propose";
        rename = "town rename";
        repo = "town repo";
        "set-parent" = "town set-parent";
        sync = "town sync";
        up = "town up";
      };
      core = {
        autocrlf = "input";
      };
      credential = {
        helper = "osxkeychain";
      };
      hub = {
        protocol = "git";
      };
      init = {
        defaultBranch = "main";
      };
      rerere = {
        enabled = true;
      };
      mergetool = {
        intellij = {
          cmd = "idea merge $LOCAL $REMOTE";
          trustExitCode = true;
        };
      };
      difftool = {
        intellij = {
          cmd = "idea diff $LOCAL $REMOTE";
          trustExitCode = true;
        };
      };
      gpg = {
        ssh = {
          allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
        };
      };
      commit = {
        gpgsign = true;
      };
      tag = {
        gpgsign = true;
      };
    };
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
    includes = [
      { path = "${config.home.homeDirectory}/.config/git/user-from-secrets"; }
    ];
  };

  # Generate SSH signing key if it doesn't exist.
  home.activation.generateSSHKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    sshDir="${config.home.homeDirectory}/.ssh"
    sshKey="$sshDir/id_ed25519"

    if [ ! -f "$sshKey" ]; then
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$sshDir"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 700 "$sshDir"

      # Get email from secrets if available.
      emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"
      if [ -f "$emailSecret" ]; then
        userEmail="$(${pkgs.coreutils}/bin/cat "$emailSecret")"
      else
        userEmail="${config.home.username}@local"
      fi

      echo "Generating SSH key for signing commits..."
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "$userEmail" -f "$sshKey" -N ""
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 600 "$sshKey"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 644 "$sshKey.pub"
      echo "SSH key generated at $sshKey"
    fi
  '';

  # Create allowed_signers file for local commit verification.
  home.activation.setupAllowedSigners = lib.hm.dag.entryAfter [ "generateSSHKey" ] ''
    allowedSignersFile="${config.home.homeDirectory}/.config/git/allowed_signers"
    sshPubKey="${config.home.homeDirectory}/.ssh/id_ed25519.pub"
    emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"

    if [ -f "$sshPubKey" ]; then
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "${config.home.homeDirectory}/.config/git"

      # Get email from secrets if available.
      if [ -f "$emailSecret" ]; then
        userEmail="$(${pkgs.coreutils}/bin/cat "$emailSecret")"
      else
        userEmail="${config.home.username}@local"
      fi

      # Create allowed_signers file.
      pubKey="$(${pkgs.coreutils}/bin/cat "$sshPubKey")"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/printf "%s %s\n" "$userEmail" "$pubKey" > "$allowedSignersFile"
    fi
  '';

  # Create git user config from secrets when available.
  home.activation.setupGitUser = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    secretsConfig="${config.home.homeDirectory}/.config/git/user-from-secrets"
    nameSecret="${config.home.homeDirectory}/.config/git-secrets/name"
    emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"

    if [ -f "$nameSecret" ] && [ -f "$emailSecret" ]; then
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "${config.home.homeDirectory}/.config/git"
      userName="$(${pkgs.coreutils}/bin/cat "$nameSecret")"
      userEmail="$(${pkgs.coreutils}/bin/cat "$emailSecret")"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/printf "[user]\n" > "$secretsConfig"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/printf "    name = %s\n" "$userName" >> "$secretsConfig"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/printf "    email = %s\n" "$userEmail" >> "$secretsConfig"
    fi
  '';
}
