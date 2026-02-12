{
  pkgs,
  inputs,
  config,
  ...
}:

let
  sslCertDir = "${pkgs.cacert}/etc/ssl/certs";
  sslCertFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
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
    packages = with pkgs; [
      fastfetch
      neofetch
      git
      wget
      curl
      unzip

      # Monitoring
      btop

      # TUI App
      lazygit
      lazydocker

      # AI
      github-copilot-cli
      claude-code
      opencode

      # Editor
      vim

      # Shell
      fish

      # Docker
      docker
      docker-compose
    ];
  };

  imports = [
    inputs.sops-nix.homeModules.sops
    ./git.nix
    ./tmux.nix
    ./fonts.nix

    # vim
    inputs.nixvim.homeModules.nixvim
    ./nvim
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;

  sops.age.sshKeyPaths = [
    "${config.home.homeDirectory}/.ssh/id_default"
  ];

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
        export DOCKER_HOST=unix:///var/run/docker.sock

        # SSH agent setup
        if not set -q SSH_AUTH_SOCK
            eval (ssh-agent -c)
            ssh-add ~/.ssh/id_default >/dev/null 2>&1
            ssh-add ~/.ssh/id_work >/dev/null 2>&1
        end

        # Auto-launch tmux
        if status --is-interactive
        and not set -q TMUX
            exec tmux new-session -A -s sessionX
        end
      '';
      shellAliases = {
        ls = "eza --icons";
        ll = "eza -l -a --icons --git";
        lt = "eza --tree --level=2 --icons";
        cat = "bat";
        nv = "nvim";
      };

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

      shellAliases = {
        ls = "eza --icons";
        ll = "eza -l -a --icons --git";
        lt = "eza --tree --level=2 --icons";
        cat = "bat";
        nv = "nvim";
      };

      initExtra = ''
        # Set locale for UTF-8 support
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        # Fix SSL certificates for copilot-cli
        export SSL_CERT_DIR=${sslCertDir}
        export SSL_CERT_FILE=${sslCertFile}

        # Docker configuration
        export DOCKER_HOST=unix:///var/run/docker.sock

        # SSH agent setup
        if [ -z "$SSH_AUTH_SOCK" ]; then
            eval $(ssh-agent -s)
            ssh-add ~/.ssh/id_default >/dev/null 2>&1
            ssh-add ~/.ssh/id_work >/dev/null 2>&1
        fi

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
  };
}
