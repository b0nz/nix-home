{
  pkgs,
  lib,
  config,
  user,
  stateVersion,
  ...
}:
{
  system.stateVersion = stateVersion.nixos;

  wsl = {
    enable = true;
    defaultUser = user;
    useWindowsDriver = true;
  };

  networking.hostName = "LocaldevWSL";

  # Set locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  nixpkgs.config.allowUnfree = true;

  # Install fish shell system-wide
  environment.shells = with pkgs; [ fish ];
  environment.systemPackages = with pkgs; [
    fish
    gcc
    gnumake
    python3
    jq
  ];

  # Enable fish shell program
  programs.fish.enable = true;

  # SOPS configuration & secrets
  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    secrets = {
      ssh_id_default = {
        sopsFile = ../../secrets/secrets.yaml;
        owner = user;
        path = "/home/${user}/.ssh/id_default";
        mode = "0600";
      };
      cloudflared_token = {
        sopsFile = ../../secrets/secrets.yaml;
        owner = user;
      };
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    description = user;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "kvm"
      "adbusers"
      "docker"
    ];
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ user ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  security.sudo.wheelNeedsPassword = true;

  programs.nix-ld.enable = true;

  hardware.graphics = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  # Cloudflared service (Manual start using sops token)

  systemd.services.cloudflared-manual = {
    description = "Cloudflared Tunnel (Manual)";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run --token-file ${config.sops.secrets.cloudflared_token.path}";
      Restart = "always";
      User = user;
    };
  };
  systemd.services.cloudflared-manual.wantedBy = lib.mkForce [ ];
}
