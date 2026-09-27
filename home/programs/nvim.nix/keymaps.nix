_: {
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "List buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "Help tags";
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Prev buffer";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<CR>";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options.desc = "LazyGit";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<CR>";
      options.desc = "Quit";
    }
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }
    {
      mode = "n";
      key = "<leader>uC";
      action = "<cmd>Telescope colorscheme<CR>";
      options.desc = "Colorscheme picker";
    }
    {
      mode = [
        "n"
        "i"
        "v"
      ];
      key = "<C-LeftMouse>";
      action = "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>";
      options.desc = "Go to definition";
    }
  ];

  # names for <leader> groups so which-key shows a label instead of "+N keymap"
  programs.nixvim.plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>f";
      group = "Find";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>t";
      group = "Toggle";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>c";
      group = "AI Chat";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>o";
      group = "Neorg";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>z";
      group = "Zen";
      icon = "🧘";
    }
    {
      __unkeyed-1 = "<leader>n";
      group = "Neorg Search";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>b";
      group = "Buffer";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>g";
      group = "Git";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>u";
      group = "UI";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>x";
      group = "Diagnostics";
      icon = "";
    }
  ];
}
