{ pkgs }:

{
  home.packages = with pkgs; [
    # Browser
    brave

    # Window Tiling
    rectangle

    # Terminal
    ghostty-bin

    # Utils
    maccy
  ];
}
