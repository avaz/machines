# Useful commands

## Fresh machine bootstrap

```shell
# First run when darwin-rebuild is not installed yet
sudo nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin/master#darwin-rebuild -- \
  switch --flake ~/.config/machines#<machine>

# Normal rebuild once darwin-rebuild is available
sudo darwin-rebuild switch --flake ~/.config/machines#<machine>
```

## Defaults troubleshooting

```shell
# Show whether the active generation still contains universalaccess writes
grep -n "com.apple.universalaccess" /run/current-system/activate

# Show whether the target syntho build contains universalaccess writes
nix build ~/.config/machines#darwinConfigurations.syntho.system --no-link --print-out-paths \
  | xargs -I{} grep -n "com.apple.universalaccess" {}/activate
```

## Terminal profile checks

```shell
# Confirm the profile is registered in Terminal preferences
/usr/libexec/PlistBuddy -c "Print :'Window Settings':'.JoeTerminal'" \
  ~/Library/Preferences/com.apple.Terminal.plist

# Confirm default/startup profile values
defaults read com.apple.Terminal "Default Window Settings"
defaults read com.apple.Terminal "Startup Window Settings"
```

## Commands for `macOS launchd`

To manually run a stop and run a service:

```shell
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.avaz.colima.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.avaz.colima.plist
```