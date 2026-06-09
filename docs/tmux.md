# Tmux Cheat Sheet

A reference for the tmux configuration in `home/tmux.nix`.

## Key

| Action | Binding |
|---|---|
| Prefix | `C-b` |

## Pane Management

| Action | Binding |
|---|---|
| Split horizontally | `C-b` `\|` |
| Split vertically | `C-b` `-` |
| Navigate left | `C-b` `h` |
| Navigate down | `C-b` `j` |
| Navigate up | `C-b` `k` |
| Navigate right | `C-b` `l` |
| Resize left | `C-b` `H` |
| Resize down | `C-b` `J` |
| Resize up | `C-b` `K` |
| Resize right | `C-b` `L` |

## Copy Mode (vi)

| Action | Binding |
|---|---|
| Enter copy mode | `C-b` `[` |
| Begin selection | `v` |
| Yank selection | `y` |
| Rectangle toggle | `r` |
| Copy-pipe (newline) | `Enter` |
| Double-click | Select word and copy |
| Triple-click | Select line and copy |

## Session Persistence

- **resurrect**: manually save/restore sessions with `C-b C-s` (save) / `C-b C-r` (restore)
- **continuum**: automatically saves every 15 minutes and restores on tmux start

## Status Bar

- Positioned at the **top** of the screen
- Catppuccin Macchiato theme
- Pane borders: subtle `#45475a` with top labels
- Right status shows session name

## Plugins

| Plugin | Purpose |
|---|---|
| sensible | Sensible tmux defaults |
| yank | System clipboard integration (WSL-compatible via `wsl-copy`) |
| resurrect | Session save/restore |
| continuum | Auto-save and restore on startup |
| catppuccin | Macchiato color scheme |

## WSL Clipboard

On WSL, yank pipes through a custom `wsl-copy` script that converts UTF-8 to UTF-16LE and pipes to `clip.exe`, ensuring proper clipboard handling from WSL to Windows.
