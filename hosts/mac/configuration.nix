{ pkgs, ... }:

let
  user = "b0nz";
in
{
  # nix-darwin specific settings

  networking.hostName = "LocaldevMac";

  # User configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.fish;
  };
  # Docker for Mac
  environment.variables.DOCKER_HOST = "unix:///Users/${user}/.colima/default/docker.sock";
  # Homebrew (optional, if you want to use it alongside Nix)
  homebrew = {
    enable = true;
    brews = [
      # utils
      "mole"
    ];
    casks = [
      "cloudflare-warp"
      "steam"
      "rectangle"
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
  programs.fish = {
    enable = true;
    shellInit = ''
      fish_add_path /opt/homebrew/bin
    '';
  };

  # Add more configuration as needed
}
