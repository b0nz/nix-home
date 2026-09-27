{ pkgs, ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./editing.nix
    ./lsp.nix
    ./git.nix
    ./navigations.nix
    ./writing.nix
    ./ai.nix
    ./dashboard.nix
    ./secrets.nix
    ./ui.nix
    ./plugin-managers.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    version.enableNixpkgsReleaseCheck = false;
    nixpkgs.source = pkgs.path;
    nixpkgs.config.allowUnfree = true;
  };
}
