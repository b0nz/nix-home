{ pkgs, config, lib, ... }:

{
  # Enable fontconfig for both platforms
  fonts.fontconfig.enable = true;

  # Install FiraCode nerdfonts package for both platforms  
  home.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # macOS-specific font activation
  home.activation.installFonts = lib.mkIf pkgs.stdenv.isDarwin (
    config.lib.dag.entryAfter ["writeBoundary"] ''
      if [ -d "${config.home.path}/share/fonts" ]; then
        $DRY_RUN_CMD find -L "${config.home.path}/share/fonts" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec ln -sf {} "$HOME/Library/Fonts/" \;
      fi
    ''
  );
}