{
  pkgs,
  inputs,
  config,
  ...
}:

let
  sslCertDir = "${pkgs.cacert}/etc/ssl/certs";
  sslCertFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  # Platform-conditional SSH agent init
  # macOS: system ssh-agent via launchd, passphrases in Keychain
  # Linux: custom ssh-agent per session
  fishSshInit =
    if pkgs.stdenv.isDarwin then
      ''
        if set -q SSH_AUTH_SOCK
            ssh-add --apple-use-keychain ~/.ssh/id_default >/dev/null 2>&1
            ssh-add --apple-use-keychain ~/.ssh/id_work >/dev/null 2>&1
        end
      ''
    else
      ''
        if not set -q SSH_AUTH_SOCK
            eval (ssh-agent -c)
            ssh-add ~/.ssh/id_default >/dev/null 2>&1
            ssh-add ~/.ssh/id_work >/dev/null 2>&1
        end
      '';

  bashSshInit =
    if pkgs.stdenv.isDarwin then
      ''
        if [ -n "$SSH_AUTH_SOCK" ]; then
            ssh-add --apple-use-keychain ~/.ssh/id_default >/dev/null 2>&1
            ssh-add --apple-use-keychain ~/.ssh/id_work >/dev/null 2>&1
        fi
      ''
    else
      ''
        if [ -z "$SSH_AUTH_SOCK" ]; then
            eval $(ssh-agent -s)
            ssh-add ~/.ssh/id_default >/dev/null 2>&1
            ssh-add ~/.ssh/id_work >/dev/null 2>&1
        fi
      '';

  sharedShellAliases = {
    ls = "eza --icons";
    ll = "eza -l -a --icons --git";
    lt = "eza --tree --level=2 --icons";
    cat = "bat";
    nv = "nvim";
    g = "git";
  };
in

{
  home = rec {
    username = "b0nz";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.11";

    # Set fish as default shell
    sessionVariables = {
      SHELL = "${pkgs.fish}/bin/fish";
    };

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages =
      with pkgs;
      [
        fastfetch
        neofetch
        git
        wget
        curl
        unzip
        ripgrep

        # Network
        cloudflared

        # Monitoring
        btop

        # TUI App
        gitui
        # lazygit
        lazydocker

        # AI
        github-copilot-cli
        claude-code
        opencode
        ollama

        # Editor
        vim
        neovim
        obsidian

        # Shell
        fish

        # Docker
        docker
        docker-compose
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (import ./mac-apps.nix { inherit pkgs; }).home.packages;
  };

  imports = [
    inputs.sops-nix.homeModules.sops
    ./git.nix
    ./tmux.nix
    ./fonts.nix

    # vim
    # inputs.nixvim.homeModules.nixvim
    # ./nvim
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;

  sops.age.sshKeyPaths = [
    "${config.home.homeDirectory}/.ssh/id_default"
  ];

  # Fix sops-nix launchd PATH on macOS (needs getconf in /usr/bin)
  launchd.agents.sops-nix.config.EnvironmentVariables.PATH =
    pkgs.lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";

  programs = {
    home-manager.enable = true;

    # Enable a nice shell prompt (Starship)
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    # `ls` alternative
    eza = {
      enable = true;
      git = true; # Show git status in list view
      icons = "auto"; # Show icons next to files
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    # `cat` alternative
    bat = {
      enable = true;
      config = {
        theme = "Dracula"; # or "GitHub", "Nord", etc.
      };
    };

    # Fish Configuration
    fish = {
      enable = true;
      interactiveShellInit = ''
        # Set locale for UTF-8 support
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        # Fix SSL certificates for copilot-cli
        export SSL_CERT_DIR=${sslCertDir}
        export SSL_CERT_FILE=${sslCertFile}

        # Docker configuration
        if test (uname) = "Darwin"
            set -gx DOCKER_HOST "unix://$HOME/.colima/default/docker.sock"
        else
            set -gx DOCKER_HOST "unix:///var/run/docker.sock"
        end

        # SSH agent setup
        ${fishSshInit}

        # Auto-launch tmux
        if status --is-interactive
        and not set -q TMUX
            exec tmux new-session -A -s sessionX
        end
      '';
      shellAliases = sharedShellAliases;

      functions = {
        fish_greeting = {
          body = "";
        };
      };
    };

    # Bash Configuration (keep for compatibility)
    bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = sharedShellAliases;

      initExtra = ''
        # Set locale for UTF-8 support
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        # Fix SSL certificates for copilot-cli
        export SSL_CERT_DIR=${sslCertDir}
        export SSL_CERT_FILE=${sslCertFile}

        # Docker configuration
        if [ "$(uname)" = "Darwin" ]; then
            export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
        else
            export DOCKER_HOST="unix:///var/run/docker.sock"
        fi

        # SSH agent setup
        ${bashSshInit}

        # Auto-launch tmux
        if [ -n "$BASH_VERSION" ] && [ -z "$TMUX" ] && [ -t 1 ]; then
            exec tmux new-session -A -s sessionX
        fi
      '';
    };

    # Direnv Configuration
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # SSH client config
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          extraOptions = {
            AddKeysToAgent = "yes";
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
            UseKeychain = "yes";
          };
        };
      };
    };
  };
}
