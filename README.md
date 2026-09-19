# nix-home

Personal Nix-based home and system configuration, managing macOS (aarch64-darwin) and WSL2/NixOS (x86_64-linux) from a single flake.

## Structure

```
├── flake.nix              # Entry point
├── flake.lock             # Locked dependency versions
├── .sops.yaml             # SOPS age encryption config
├── lib/
│   └── default.nix        # Shared config (user, stateVersion)
├── nix/
│   ├── outputs.nix        # Flake output assembly
│   ├── dev-shells.nix     # Development shells (node, go, rust, android, pentest)
│   └── pre-commit.nix     # Pre-commit hooks config
├── hosts/
│   ├── mac/               # nix-darwin system config (macOS)
│   └── wsl/               # NixOS-WSL system config
├── home/
│   ├── default.nix        # Home-manager entry point (sops, eza, bat)
│   ├── packages.nix       # User packages
│   ├── git.nix            # Git with SOPS conditional identities
│   ├── tmux.nix           # Tmux with Catppuccin theme (see docs/tmux.md)
│   ├── fonts.nix          # FiraCode Nerd Font
│   ├── starship.toml      # Starship prompt theme
│   ├── shell/
│   │   ├── aliases.nix    # Shared shell aliases (ls, git shortcuts)
│   │   ├── fish.nix       # Fish shell config
│   │   └── bash.nix       # Bash shell config
│   ├── programs/
│   │   ├── ssh.nix        # SSH client config
│   │   └── direnv.nix     # Direnv + nix-direnv
│   ├── appearance/
│   │   └── starship.nix   # Starship prompt + gruvbox theme variant
│   └── platform/
│       └── darwin.nix     # macOS-specific packages and launchd config
├── docs/
│   └── tmux.md            # Tmux keybindings and config reference
└── secrets/
    └── secrets.yaml       # SOPS-encrypted secrets
```

## Setup

### WSL2 / NixOS

```sh
# Requires: NixOS-WSL installed with flakes enabled
git clone git@github.com:b0nz/nix-home.git ~/.config/nix-home

# Bootstrap SOPS age key (once, on fresh install)
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_default > ~/.config/sops/age/keys.txt

sudo nixos-rebuild switch --flake ~/.config/nix-home#LocaldevWSL
```

### macOS (nix-darwin + home-manager)

```sh
# Requires: Determinate Nix installer
git clone git@github.com:b0nz/nix-home.git ~/.config/nix-home
darwin-rebuild switch --flake ~/.config/nix-home#LocaldevMac
```

## Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) using age encryption.

- `secrets/secrets.yaml` contains: personal email, work email, cloudflared token, SSH private key
- The age key at `~/.config/sops/age/keys.txt` is required to decrypt — keep a backup in a password manager
- On WSL, sops-nix deploys `ssh_id_default` to `~/.ssh/id_default` (mode 0600) at system activation
- Git uses SOPS templated configs for conditional per-repo identity:
  - `git-personal` — default for all repos
  - `git-work` — activated for repos under `~/work/`

## Dev Shells

```sh
nix develop .#nodejs22  # Node 22 + pnpm
nix develop .#nodejs24  # Node 24 + pnpm
nix develop .#go        # Go + gopls + golangci-lint + delve
nix develop .#rust      # Rust + rust-analyzer + clippy
nix develop .#android   # Android SDK/Studio + zulu17
nix develop .#pentest   # Recon, web testing, OSINT, exploit tools
```

Or use [devenv](https://devenv.sh) for per-project environments with direnv integration:

```sh
devenv init
echo "use devenv" > .envrc
direnv allow
```

## Key Programs

- **Shell**: fish + starship prompt + theme.sh (terminal theme switcher)
- **Terminal multiplexer**: tmux (Catppuccin Macchiato) — [keybindings & config](docs/tmux.md)
- **Editor**: Neovim, Vim
- **Git**: lazygit, gitui — shell aliases via `g`-prefix (`gs`, `gp`, `glg`, ...)
- **AI**: Claude Code, GitHub Copilot CLI, opencode, antigravity-cli
- **Utils**: eza, bat, fzf, ripgrep, direnv, btop
