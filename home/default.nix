{
  pkgs,
  osConfig,
  inputs,
  config,
  ...
}:

{
  home = rec {
    username = "b0nz";
    homeDirectory = osConfig.users.users.${username}.home;
    stateVersion = "25.05";

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
    ];
  };

  imports = [
    inputs.sops-nix.homeModules.sops
    ./git.nix

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

    # Bash Configuration
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
    };

    # Direnv Configuration
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
