{ pkgs, config, ... }:

let
  user = "b0nz";
in
{
  # nix-darwin specific settings

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
    stateVersion = 5;
    primaryUser = "b0nz";

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

  # Nix settings - disabled to work with Determinate Nix
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Security settings
  security.pam.services.sudo_local.touchIdAuth = true;

  # Programs
  programs.fish.enable = true;

  # Add more configuration as needed
}