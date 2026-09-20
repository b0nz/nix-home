{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    spotify
    ghostty-bin
    maccy
    colima
  ];

  # home-manager's man module has no package to generate caches with on
  # Darwin (macOS ships its own man/mandoc), so disable it to avoid:
  # "programs.man.generateCaches has no effect when programs.man.package is null"
  programs.man.generateCaches = false;

  # sops-nix launchd on macOS needs getconf which lives outside the Nix PATH
  launchd.agents.sops-nix.config.EnvironmentVariables.PATH =
    lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
}
