_: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      smarttab = true;
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      termguicolors = true;
      signcolumn = "yes";
      scrolloff = 8;
      splitright = true;
      splitbelow = true;
      wrap = false;
      swapfile = false;
      undofile = true;
      updatetime = 200;
      timeoutlen = 300;
      clipboard = "unnamedplus";
      laststatus = 3;
      cmdheight = 0;
      mouse = "";
      encoding = "utf8";
      backspace = [
        "indent"
        "eol"
        "start"
      ];
      background = "dark";
      compatible = false;
      conceallevel = 3;
      concealcursor = "n";
    };
  };
}
