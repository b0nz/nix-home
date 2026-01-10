{ pkgs, ... }:

let
  user = "b0nz";
in
{
  # nix-darwin specific settings
  services.nix-daemon.enable = true;

  networking.hostName = "LocaldevMac";

  # System packages
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];

  # User configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.fish;
  };

  # Docker for Mac
  environment.variables.DOCKER_HOST = "unix:///var/run/docker.sock";

  # Homebrew (optional, if you want to use it alongside Nix)
  homebrew = {
    enable = true;
    brews = [
      # Add homebrew formulae here
    ];
    casks = [
      # Add homebrew casks here
    ];
  };

  # System settings
  system = {
    stateVersion = 4;

    defaults = {
      # Finder settings
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;

      # Dock settings
      dock.autohide = true;
      dock.mru-spaces = false;

      # Other defaults
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  # Nix settings
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    settings.auto-optimise-store = true;
  };

  # Security settings
  security.pam.enableSudoTouchIdAuth = true;

  # Programs
  programs.fish.enable = true;

  # Add more configuration as needed
}