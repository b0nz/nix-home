let
  # Catppuccin Macchiato, same palette as starship.toml
  c = {
    rosewater = "#f4dbd6";
    flamingo = "#f0c6c6";
    pink = "#f5bde6";
    mauve = "#c6a0f6";
    red = "#ed8796";
    maroon = "#ee99a0";
    peach = "#f5a97f";
    yellow = "#eed49f";
    green = "#a6da95";
    teal = "#8bd5ca";
    sky = "#91d7e3";
    sapphire = "#7dc4e4";
    blue = "#8aadf4";
    lavender = "#b7bdf8";
    text = "#cad3f5";
    subtext1 = "#b8c0e0";
    subtext0 = "#a5adcb";
    overlay2 = "#939ab7";
    overlay1 = "#8087a2";
    overlay0 = "#6e738d";
    surface2 = "#5b6078";
  };
  fg = color: { foreground = color; };
in
{
  programs.eza.theme = {
    filekinds = {
      normal = fg c.text;
      directory = fg c.blue;
      symlink = fg c.teal;
      pipe = fg c.overlay1;
      block_device = fg c.red;
      char_device = fg c.red;
      socket = fg c.overlay1;
      special = fg c.mauve;
      executable = fg c.green;
      mount_point = fg c.sapphire;
    };
    perms = {
      user_read = fg c.yellow;
      user_write = fg c.red;
      user_execute_file = fg c.green;
      user_execute_other = fg c.green;
      group_read = fg c.yellow;
      group_write = fg c.red;
      group_execute = fg c.green;
      other_read = fg c.yellow;
      other_write = fg c.red;
      other_execute = fg c.green;
      special_user_file = fg c.mauve;
      special_other = fg c.mauve;
      attribute = fg c.subtext0;
    };
    size = {
      major = fg c.subtext0;
      minor = fg c.sky;
      number_byte = fg c.green;
      number_kilo = fg c.green;
      number_mega = fg c.yellow;
      number_giga = fg c.peach;
      number_huge = fg c.red;
      unit_byte = fg c.teal;
      unit_kilo = fg c.teal;
      unit_mega = fg c.teal;
      unit_giga = fg c.teal;
      unit_huge = fg c.teal;
    };
    users = {
      user_you = fg c.lavender;
      user_root = fg c.red;
      user_other = fg c.mauve;
      group_yours = fg c.lavender;
      group_other = fg c.mauve;
      group_root = fg c.red;
    };
    links = {
      normal = fg c.teal;
      multi_link_file = fg c.peach;
    };
    git = {
      new = fg c.green;
      modified = fg c.yellow;
      deleted = fg c.red;
      renamed = fg c.teal;
      typechange = fg c.mauve;
      ignored = fg c.overlay0;
      conflicted = fg c.maroon;
    };
    git_repo = {
      branch_main = fg c.green;
      branch_other = fg c.mauve;
      git_clean = fg c.green;
      git_dirty = fg c.yellow;
    };
    security_context = {
      colon = fg c.overlay1;
      user = fg c.lavender;
      role = fg c.mauve;
      typ = fg c.blue;
      range = fg c.sky;
    };
    file_type = {
      image = fg c.pink;
      video = fg c.flamingo;
      music = fg c.sky;
      lossless = fg c.sapphire;
      crypto = fg c.red;
      document = fg c.rosewater;
      compressed = fg c.peach;
      temp = fg c.overlay1;
      compiled = fg c.green;
      build = fg c.yellow;
      source = fg c.blue;
    };
    punctuation = fg c.overlay2;
    date = fg c.sapphire;
    inode = fg c.subtext0;
    blocks = fg c.subtext0;
    header = fg c.subtext1;
    octal = fg c.mauve;
    flags = fg c.mauve;
    symlink_path = fg c.teal;
    control_char = fg c.sapphire;
    broken_symlink = fg c.red;
    broken_path_overlay = fg c.surface2;
  };
}
