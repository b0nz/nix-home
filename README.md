# nix-home

Personal Nix-based home and system configuration, managing macOS (aarch64-darwin) and WSL2/NixOS (x86_64-linux) from a single flake.

## Structure

```
├── flake.nix              # Entry point
├── flake.lock             # Locked dependency versions
├── .sops.yaml             # SOPS age encryption config
├── .pre-commit-config.yaml # Generated pre-commit hooks (deadnix, nixfmt, statix, shellcheck, stylua)
├── nix/
│   ├── outputs.nix        # Flake output assembly
│   ├── dev-shells.nix     # Development shells (node, go, rust, android)
│   └── pre-commit.nix     # Pre-commit hooks config
├── hosts/
│   ├── mac/               # nix-darwin system config (macOS)
│   └── wsl/               # NixOS-WSL system config
├── home/
│   ├── default.nix        # Home-manager user config
│   ├── git.nix            # Git with SOPS conditional identities
│   ├── tmux.nix           # Tmux with Catppuccin theme (see docs/tmux.md)
│   ├── fonts.nix          # FiraCode Nerd Font
│   ├── mac-apps.nix       # macOS-specific packages
│   ├── starship.toml      # Starship prompt theme
├── docs/
│   └── tmux.md            # Tmux keybindings and config reference
└── secrets/
    └── secrets.yaml       # SOPS-encrypted secrets
```

## Setup

### macOS (nix-darwin + home-manager)

```sh
# Requires: Determinate Nix installer (or nix with flakes enabled)
git clone git@github.com:b0nz/nix-home.git ~/.config/nix-home
# Decrypt SOPS secrets (age key must be available)
darwin-rebuild switch --flake ~/.config/nix-home#LocaldevMac
```

### WSL2 / NixOS

```sh
# Requires: NixOS-WSL installed with flakes enabled
git clone git@github.com:b0nz/nix-home.git ~/.config/nix-home
sudo nixos-rebuild switch --flake ~/.config/nix-home#LocaldevWSL
```

## Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) using age encryption.

- `secrets/secrets.yaml` contains: personal email, work email, WSL user password
- Git uses SOPS templated configs for conditional per-repo identity:
  - `git-personal` — default for all repos
  - `git-work` — activated for repos under `~/work/`

## Dev Shells

```sh
nix develop .#nodejs22  # Node 22 + pnpm
nix develop .#go         # Go + gopls + golangci-lint + delve
nix develop .#rust       # Rust + rust-analyzer + clippy
nix develop .#android    # Android SDK/Studio + zulu17
```

## Key Programs

- **Shell**: fish + starship prompt
- **Terminal multiplexer**: tmux (Catppuccin Macchiato) — [keybindings & config](docs/tmux.md)
- **Editor**: Neovim (via LazyVim), Vim
- **Git**: eza, bat, lazygit, direnv
- **AI**: Claude Code, GitHub Copilot CLI, opencode
