{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    spotify
    ghostty-bin
    maccy
    colima
  ];

  # sops-nix launchd on macOS needs getconf which lives outside the Nix PATH
  launchd.agents.sops-nix.config.EnvironmentVariables.PATH =
    lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
}
