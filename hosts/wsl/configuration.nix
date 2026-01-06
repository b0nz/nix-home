{ pkgs, ... }:

let
  user = "b0nz";
in
{
  system.stateVersion = "25.11";

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
  environment.systemPackages = with pkgs; [ fish ];

  # Enable fish shell program
  programs.fish.enable = true;

  # SOPS configuration
  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  # SOPS secrets
  sops.secrets.user_password = {
    sopsFile = ../../secrets/secrets.yaml;
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
    ]; # 'wheel' allows sodo

    # Use SOPS encrypted hashed password
    hashedPasswordFile = "/run/secrets/user_password";
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.auto-optimise-store = true;
  };

  security.sudo.wheelNeedsPassword = true;

  programs.nix-ld.enable = true;

  hardware.graphics = {
    enable = true;
  };
}
