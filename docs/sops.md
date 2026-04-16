## Quick Reference: sops-nix Commands

### Viewing Secrets

```bash
# View decrypted secrets
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d config/main/secrets.yaml

# Or set the environment variable permanently in your shell profile
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
sops -d config/main/secrets.yaml
```

### Editing Secrets

```bash
# Edit secrets (will open in your $EDITOR)
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops config/main/secrets.yaml
```
## Adding a New Secret

1. Edit the secrets file:
   ```bash
   SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops config/main/secrets.yaml
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

3. Declare the secret in `config/main/secrets.nix`:
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
head config/main/secrets.yaml

# Re-encrypt if needed
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --encrypt --in-place config/main/secrets.yaml
```

