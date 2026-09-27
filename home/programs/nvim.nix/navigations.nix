_:
let
  resize.up = ''
    function()
      vim.cmd [[ resize +1 ]]
    end
  '';
  resize.down = ''
    function()
      vim.cmd [[ resize -1 ]]
    end
  '';
  resize.left = ''
    function()
      vim.cmd [[ vertical resize -1 ]]
    end
  '';
  resize.right = ''
    function()
      vim.cmd [[ vertical resize +1 ]]
    end
  '';
in
{
  programs.nixvim = {
    plugins = {
      telescope = {
        enable = true;
        lazyLoad.settings.cmd = "Telescope";
        keymaps = {
          "<leader>ff".options.desc = "Find by files";
          "<leader>ff".action = "find_files";
          "<leader>fF".options.desc = "Find by words";
          "<leader>fF".action = "live_grep";
          "<leader>f'".options.desc = "Find by String";
          "<leader>f'".action = "grep_string";
          "<leader>fb".options.desc = "Find by current buffers";
          "<leader>fb".action = "buffers";
          "<leader>fB".options.desc = "Find Fuzz by current buffers";
          "<leader>fB".action = "current_buffer_fuzzy_find";
          "<leader>fh".options.desc = "Find by help tags";
          "<leader>fh".action = "help_tags";
          "<leader>fc".options.desc = "Find by Colorscheme";
          "<leader>fc".action = "colorscheme";
          "<leader>fC".options.desc = "Find by highlights";
          "<leader>fC".action = "highlights";
        };
      };

      hop = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings.event = "VimEnter";
        };
      };

      which-key.enable = true;
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>nn";
          __unkeyed-2 = "<cmd>new<cr>";
          desc = "New Buffer Horizontal";
          icon = "─";
        }
        {
          __unkeyed-1 = "<leader>ns";
          __unkeyed-2 = "<cmd>vnew<cr>";
          desc = "New Buffer Vertical";
          icon = "│";
        }
        {
          __unkeyed-1 = "<c-a>";
          __unkeyed-2 = "<cmd>sp<cr>";
          desc = "Split Horizontal";
          icon = "─";
        }
        {
          __unkeyed-1 = "<c-s>";
          __unkeyed-2 = "<cmd>vsp<cr>";
          desc = "Split Vertical";
          icon = "│";
        }
        {
          __unkeyed-1 = "<leader>ft";
          __unkeyed-2 = "<cmd>Telescope<cr>";
          desc = "Open Telescope";
          icon = "";
        }
        {
          __unkeyed-1 = "Y";
          __unkeyed-2 = "\"+yy";
          desc = "Copy to Clipboard!";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>p";
          __unkeyed-2 = "\"+p";
          desc = "Paste from Clipboard";
          icon = "";
        }
        {
          __unkeyed-1 = "<c-h>";
          __unkeyed-2 = "<c-w>h";
          desc = "Move top";
          icon = "←";
        }
        {
          __unkeyed-1 = "<c-j>";
          __unkeyed-2 = "<c-w>j";
          desc = "Move down";
          icon = "↓";
        }
        {
          __unkeyed-1 = "<c-k>";
          __unkeyed-2 = "<c-w>k";
          desc = "Move left";
          icon = "↑";
        }
        {
          __unkeyed-1 = "<c-l>";
          __unkeyed-2 = "<c-w>l";
          desc = "Move right";
          icon = "→";
        }
        {
          __unkeyed-1 = "<leader>fw";
          __unkeyed-2 = "<cmd>HopWord<cr>";
          desc = "Find by Word";
        }
        {
          __unkeyed-1 = "<leader>fhh";
          __unkeyed-2 = "<cmd>HopPattern<cr>";
          desc = "Find by Patterns";
        }
        {
          __unkeyed-1 = "<up>";
          __unkeyed-2.__raw = resize.up;
          desc = "resize window up";
        }
        {
          __unkeyed-1 = "<down>";
          __unkeyed-2.__raw = resize.down;
          desc = "resize window down";
        }
        {
          __unkeyed-1 = "<left>";
          __unkeyed-2.__raw = resize.left;
          desc = "resize window right";
        }
        {
          __unkeyed-1 = "<right>";
          __unkeyed-2.__raw = resize.right;
          desc = "resize window left";
        }
      ];
    };
  };
}
