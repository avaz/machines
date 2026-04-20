{
    config,
    lib,
    pkgs,
    ...
}:
{
    sops.templates."git-user-from-secrets" = {
        path = "${config.home.homeDirectory}/.config/git/user-from-secrets";
        content = ''
            [user]
                name = ${config.sops.placeholder."git/user/name"}
                email = ${config.sops.placeholder."git/user/email"}
        '';
    };

    programs.git = {
        enable = true;
        settings = {
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
            { path = config.sops.templates."git-user-from-secrets".path; }
        ];
    };

    # Generate SSH signing key if it doesn't exist
    home.activation.generateSSHKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
        sshDir="${config.home.homeDirectory}/.ssh"
        sshKey="$sshDir/id_ed25519"

        if [ ! -f "$sshKey" ]; then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$sshDir"
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 700 "$sshDir"

            # Get email from secrets if available
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
            echo "✅ SSH key generated at $sshKey"
        fi
    '';

    # Create allowed_signers file for local commit verification
    home.activation.setupAllowedSigners = lib.hm.dag.entryAfter ["generateSSHKey"] ''
        allowedSignersFile="${config.home.homeDirectory}/.config/git/allowed_signers"
        sshPubKey="${config.home.homeDirectory}/.ssh/id_ed25519.pub"
        emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"

        if [ -f "$sshPubKey" ]; then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "${config.home.homeDirectory}/.config/git"

            # Get email from secrets if available
            if [ -f "$emailSecret" ]; then
                userEmail="$(${pkgs.coreutils}/bin/cat "$emailSecret")"
            else
                userEmail="${config.home.username}@local"
            fi

            # Create allowed_signers file
            pubKey="$(${pkgs.coreutils}/bin/cat "$sshPubKey")"
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/printf "%s %s\n" "$userEmail" "$pubKey" > "$allowedSignersFile"
        fi
    '';

}

