{
  pkgs,
  user,
  stateVersion,
  ...
}:
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
      "jq"
    ];
    casks = [
      "cloudflare-warp"
      "steam"
      "rectangle"
    ];
  };

  # System settings
  system = {
    stateVersion = stateVersion.darwin;
    primaryUser = user;

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

  # Raise the system-wide default open-file limit (macOS defaults to a soft
  # limit of 256, which `nix flake update`/git packfile indexing can exceed)
  launchd.daemons."limit.maxfiles" = {
    serviceConfig = {
      Label = "limit.maxfiles";
      ProgramArguments = [
        "launchctl"
        "limit"
        "maxfiles"
        "65536"
        "200000"
      ];
      RunAtLoad = true;
    };
  };

  # Cloudflared LaunchAgent (Manual start)
  launchd.user.agents.cloudflared = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.cloudflared}/bin/cloudflared"
        "tunnel"
        "run"
        "--token-file"
        "/Users/${user}/.config/sops-nix/secrets/cloudflared_token"
      ];
      RunAtLoad = false;
      KeepAlive = false;
      StandardOutPath = "/var/tmp/cloudflared.log";
      StandardErrorPath = "/var/tmp/cloudflared.err";
    };
  };
}
