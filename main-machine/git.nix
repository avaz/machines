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
                    allowedSignersFile = "~/.config/git/allowed_signers";
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
            key = "~/.ssh/id_ed25519.pub";
        };
        includes = [
            { path = "~/.config/git/user"; }
        ];
    };

    # Generate SSH signing key if it doesn't exist
    home.activation.generateSSHKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
        sshDir="${config.home.homeDirectory}/.ssh"
        sshKey="$sshDir/id_ed25519"

        if [ ! -f "$sshKey" ]; then
            $DRY_RUN_CMD mkdir -p "$sshDir"
            $DRY_RUN_CMD chmod 700 "$sshDir"

            # Get email from secrets if available
            emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"
            if [ -f "$emailSecret" ]; then
                userEmail=$(cat "$emailSecret")
            else
                userEmail="$USER@$(hostname)"
            fi

            echo "Generating SSH key for signing commits..."
            $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "$userEmail" -f "$sshKey" -N ""
            $DRY_RUN_CMD chmod 600 "$sshKey"
            $DRY_RUN_CMD chmod 644 "$sshKey.pub"
            echo "✅ SSH key generated at $sshKey"
        fi
    '';

    # Create allowed_signers file for local commit verification
    home.activation.setupAllowedSigners = lib.hm.dag.entryAfter ["generateSSHKey"] ''
        allowedSignersFile="${config.home.homeDirectory}/.config/git/allowed_signers"
        sshPubKey="${config.home.homeDirectory}/.ssh/id_ed25519.pub"
        emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"

        if [ -f "$sshPubKey" ]; then
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/git"

            # Get email from secrets if available
            if [ -f "$emailSecret" ]; then
                userEmail=$(cat "$emailSecret")
            else
                userEmail="$USER@$(hostname)"
            fi

            # Create allowed_signers file
            $DRY_RUN_CMD echo "$userEmail $(cat $sshPubKey)" > "$allowedSignersFile"
        fi
    '';

    # Create git user config from secrets
    home.activation.setupGitUser = lib.hm.dag.entryAfter ["writeBoundary"] ''
        secretsConfig="${config.home.homeDirectory}/.config/git/user-from-secrets"
        nameSecret="${config.home.homeDirectory}/.config/git-secrets/name"
        emailSecret="${config.home.homeDirectory}/.config/git-secrets/email"

        if [ -f "$nameSecret" ] && [ -f "$emailSecret" ]; then
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/git"
            userName=$(cat "$nameSecret")
            userEmail=$(cat "$emailSecret")
            $DRY_RUN_CMD echo "[user]" > "$secretsConfig"
            $DRY_RUN_CMD echo "    name = $userName" >> "$secretsConfig"
            $DRY_RUN_CMD echo "    email = $userEmail" >> "$secretsConfig"
        fi
    '';
}
