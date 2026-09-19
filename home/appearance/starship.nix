{
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../starship.toml);
  };

  home.file.".config/starship-gruvbox.toml".text =
    builtins.replaceStrings
      [ "palette = \"catppuccin_macchiato\"" ]
      [ "palette = \"gruvbox_material_light_hard\"" ]
      (builtins.readFile ../starship.toml);
}
