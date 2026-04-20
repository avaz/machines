## Quick Reference: sops-nix Commands

### Viewing Secrets

```bash
# Replace <machine> with main/server/syntho
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d config/<machine>/secrets.yaml

# Or set the environment variable permanently in your shell profile
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
sops -d config/<machine>/secrets.yaml
```

### Editing Secrets

```bash
# Edit machine secrets (will open in your $EDITOR)
# NOTE: must be run from ~/.config/machines (sops looks for .sops.yaml by traversing up from cwd)
cd ~/.config/machines
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops config/<machine>/secrets.yaml

# Alternatively, run from anywhere by passing --config explicitly:
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --config ~/.config/machines/.sops.yaml ~/.config/machines/config/<machine>/secrets.yaml
```

### First Bootstrap on a Fresh Machine

The shared config now handles missing `config/<machine>/secrets.yaml` automatically,
so the first `darwin-rebuild` works without secrets present.

```bash
# 1) First apply (no secrets.yaml yet)
sudo darwin-rebuild switch --flake ~/.config/machines#<machine>

   # 2) Create secrets file (must run from ~/.config/machines so sops finds .sops.yaml)
   cd ~/.config/machines
   nix shell nixpkgs#sops -c sops config/<machine>/secrets.yaml

# 3) Apply again so sops-nix starts extracting declared secrets
sudo darwin-rebuild switch --flake ~/.config/machines#<machine>
```

## Adding a New Secret

1. Edit the machine secrets file:
   ```bash
   SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops config/<machine>/secrets.yaml
   ```

2. Add your secret in YAML format:
   ```yaml
   git:
     user:
       name: Anderson Vaz
       email: dev@andersonvaz.com
   myservice:
     api_key: secret-key-here
     token: another-secret
   ```

3. Declare the secret in `common/secrets.nix` (or a machine-specific module):
   ```nix
   secrets = {
     "myservice/api_key" = {
       path = "${config.home.homeDirectory}/.config/myservice/api_key";
     };
   };
   ```

4. Use it in your configuration:
   ```nix
   let
     apiKey = lib.strings.fileContents config.sops.secrets."myservice/api_key".path;
   in
   {
     # Use apiKey in your configuration
   }
   ```

## Troubleshooting

### Can't decrypt secrets
```bash
# Make sure your age key file is in the right location
ls -la ~/.config/sops/age/keys.txt

# Verify permissions
chmod 600 ~/.config/sops/age/keys.txt

# Check that public key in .sops.yaml matches your private key
grep "# public key:" ~/.config/sops/age/keys.txt
```

### Build fails with sops errors
```bash
# Check if secrets file is properly encrypted
head config/<machine>/secrets.yaml

# Re-encrypt if needed
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --encrypt --in-place config/<machine>/secrets.yaml
```
