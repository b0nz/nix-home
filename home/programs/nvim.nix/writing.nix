{ pkgs, ... }:
{
  programs.nixvim = {
    keymaps = [
      # move lines up and down with visual selection
      {
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        mode = [ "v" ];
      }
      {
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        mode = [ "v" ];
      }
    ];

    userCommands.Venn.desc = "Toggle Venn";
    userCommands.Venn.command.__raw = # lua
      ''
        function()
          local venn_enabled = vim.inspect(vim.b.venn_enabled)
          if venn_enabled == "nil" then
              vim.b.venn_enabled = true
              vim.cmd[[setlocal ve=all]]
              -- draw a line on HJKL keystokes
              vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
              vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
              vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
              vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
              -- draw a box by pressing "f" with visual selection
              vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
          else
              vim.cmd[[setlocal ve=]]
              vim.api.nvim_buf_del_keymap(0, "n", "J")
              vim.api.nvim_buf_del_keymap(0, "n", "K")
              vim.api.nvim_buf_del_keymap(0, "n", "L")
              vim.api.nvim_buf_del_keymap(0, "n", "H")
              vim.api.nvim_buf_del_keymap(0, "v", "f")
              vim.b.venn_enabled = nil
          end
        end
      '';

    extraPlugins = with pkgs.vimPlugins; [
      venn-nvim
    ];

    plugins = rec {
      lz-n.plugins = [
        {
          __unkeyed-1 = "venn.nvim";
          cmd = [ "Venn" ];
        }
        {
          __unkeyed-1 = "markdown-preview.nvim";
          cmd = [
            "MarkdownPreview"
            "MarkdownPreviewStop"
            "MarkdownPreviewToggle"
          ];
        }
      ];
      cmp.settings.sources = [
        { name = "neorg"; }
      ];

      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>mp";
          __unkeyed-2 = "<cmd>MarkdownPreview<cr>";
          icon = " markdown";
          desc = "Preview Markdown";
        }
        {
          __unkeyed-1 = "<leader>tv";
          __unkeyed-2 = "<cmd>Venn<CR>";
          icon = " wand";
          desc = "Toggle Venn [Ascii Draw Diagram]";
        }
        {
          __unkeyed-1 = "<leader>oj";
          __unkeyed-2 = "<cmd>Neorg journal today<cr>";
          icon = " journal";
          desc = "Journal Today";
        }
        {
          __unkeyed-1 = "<leader>oh";
          __unkeyed-2 = "<cmd>Neorg workspace home<cr>";
          icon = " house";
          desc = "Open Neorg Home";
        }
        {
          __unkeyed-1 = "<leader>zm";
          __unkeyed-2 = "<cmd>ZenMode<cr>";
          icon = "🧘 philosopher";
          desc = "Focus like a Japanese Philosopher";
        }
      ];

      telescope = {
        enabledExtensions = [ "neorg" ];
        keymaps = {
          "<leader>nw".options.desc = "Switch Neorg Workspace";
          "<leader>nw".action = "neorg switch_workspace";
          "<leader>ni".options.desc = "Insert Neorg Link";
          "<leader>ni".action = "neorg insert_link";
          "<leader>nI".options.desc = "Insert Neorg File Link";
          "<leader>nI".action = "neorg insert_file_link";
          "<leader>ns".options.desc = "Find Neorg files";
          "<leader>ns".action = "neorg find_norg_files";
          "<leader>nh".options.desc = "Find Neorg by Headings";
          "<leader>nh".action = "neorg search_headings";
          "<leader>nl".options.desc = "Find Neorg Linkable";
          "<leader>nl".action = "neorg find_linkable";
          "<leader>nB".options.desc = "Find Neorg Header Backlinks";
          "<leader>nB".action = "neorg find_header_backlinks";
          "<leader>nb".options.desc = "Find Neorg Backlinks";
          "<leader>nb".action = "neorg find_backlinks";
          "<leader>nt".options.desc = "Find Neorg Project Tasks";
          "<leader>nt".action = "neorg find_project_tasks";
          "<leader>nc".options.desc = "Find Neorg Context Tasks";
          "<leader>nc".action = "neorg find_context_tasks";
        };
      };

      image.enable = true;

      markdown-preview = {
        enable = true;
        settings.theme = "dark";
        settings.port = "8686";
      };

      render-markdown = {
        enable = true;
        lazyLoad.settings.ft = "markdown";
        settings = {
          preset = "lazy";
          debounce = 100;
          max_file_size = 10.0;
        };
      };

      comment = {
        enable = true;
        lazyLoad.settings.keys = [
          "gcc"
          "gco"
          "gcO"
          "gcA"
        ];
      };

      zen-mode = {
        enable = true;
        lazyLoad.settings.cmd = "ZenMode";
      };

      neorg = {
        enable = true;
        telescopeIntegration.enable = true;
        settings.lazy_loading = true;
        settings.load = {
          "core.dirman" = {
            config = {
              default_workspace = "home";
              index = "index.norg";
              open_last_workspace = false;
              workspaces = {
                home = "~/notes";
              };
            };
          };
          "core.concealer" = {
            config = {
              folds = true;
              icon_preset = "diamond";
              init_open_folds = "auto";
              icons.code_block.conceal = true;
            };
          };
          "core.completion".config.engine = "nvim-cmp";
          "core.presenter".config.zen_mode = "zen-mode";
          "core.summary".config.strategy = "by_path";
          "core.keybinds".config.neorg_leader = "<Leader>";
          "core.ui" = { };
          "core.ui.calendar" = { };
          "core.latex.renderer" = { };
          "core.defaults".__empty = null;
          "core.integrations.treesitter".config.install_parsers = false;
          "core.integrations.telescope" = { };
        };
      };
    };
  };
}
