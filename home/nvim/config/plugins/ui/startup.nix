{
  plugins.startup = {
    enable = true;

    settings = {
      colors = {
        background = "#1e2030";
        folded_section = "#363a4f";
      };

      header = {
        type = "text";
        oldfilesDirectory = false;
        align = "center";
        foldSection = false;
        title = "Header";
        content = [
          "                                   "
          "                                   "
          "                                   "
          "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          "
          "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       "
          "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     "
          "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    "
          "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   "
          "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  "
          "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   "
          " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  "
          " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ "
          "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     "
          "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     "
          "                                   "
        ];
        highlight = "Function";
        defaultColor = "";
      };

      body = {
        type = "mapping";
        oldfilesDirectory = false;
        align = "center";
        foldSection = false;
        title = "Quick Actions";
        margin = 5;
        content = [
          [
            "  Find File"
            "Telescope find_files"
            "f"
          ]
          [
            "  New File"
            "enew"
            "n"
          ]
          [
            "  Recent Files"
            "Telescope oldfiles"
            "r"
          ]
          [
            "  Find Text"
            "Telescope live_grep"
            "g"
          ]
          [
            "  Config"
            "e ~/.config/nix-home/home/nvim/config/default.nix"
            "c"
          ]
          [
            "  Quit"
            "qa"
            "q"
          ]
        ];
        highlight = "String";
        defaultColor = "";
      };

      options = {
        paddings = [
          5
          5
        ];
      };

      parts = [
        "header"
        "body"
      ];
    };
  };
}
