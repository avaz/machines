# Useful commands

## Commands for `macOS launchd`

To manually run a stop and run a service:

```shell
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.avaz.colima.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.avaz.colima.plist
```