_:

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

  nixpkgs.config.allowUnfree = true;

  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "wheel"
      "networkmanager"
      "kvm"
      "adbusers"
    ]; # 'wheel' allows sodo

    # sets the password to 'passoword' ONLY on the first creation
    initialPassword = "password";
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
