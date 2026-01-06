{
  pkgs,
  osConfig,
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
    homeDirectory = osConfig.users.users.${username}.home;
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
    ];
  };

  imports = [
    inputs.sops-nix.homeModules.sops
    ./git.nix
    ./tmux.nix

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
      '';
      shellAliases = {
        ls = "eza --icons";
        ll = "eza -l -a --icons --git";
        lt = "eza --tree --level=2 --icons";
        cat = "bat";
        nv = "nvim";
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
      '';
    };

    # Direnv Configuration
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
   };
}
