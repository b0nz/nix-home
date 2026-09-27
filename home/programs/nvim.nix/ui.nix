{ pkgs, ... }:
{
  programs.nixvim = {
    colorscheme = "gruvbox";

    globals = {
      elite_mode = 1;
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
      # edge colorscheme
      # edge_style = "neon";
      # edge_diagnostic_text_highlight = 1;
      # edge_diagnostic_line_highlight = 1;
      # edge_diagnostic_virtual_text = "grey";
      # edge_dim_foreground = 1;
      # edge_dim_inactive_windows = 1;
      # edge_float_style = "bright";
    };

    opts = {
      list = true;
      listchars = "eol:↩,nbsp:+,tab:⦙ ,trail:-";

      # depends on treesitter
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldcolumn = "0";
      foldtext = "";
      foldlevel = 99;
      foldlevelstart = 1;
      foldnestmax = 4;
    };

    extraConfigLuaPre = # lua
      ''
        if vim.fn.has('termguicolors') == 1 then
          vim.opt.termguicolors = true
        end
      '';

    autoCmd = [
      {
        event = [ "User" ];
        pattern = "LspProgressStatusUpdated";
        callback.__raw = # lua
          ''
            function()
              require('lualine').refresh()
            end
          '';
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      # colorschemes: gruvbox is active, others kept installed to switch between
      edge
      gruvbox-nvim
      lackluster-nvim
      midnight-nvim
      dracula-nvim

      # extra
      unicode-vim
      lsp-progress-nvim
      nvzone-typr
    ];

    userCommands.StatusLine.desc = "Toggle Status Line";
    userCommands.StatusLine.command.__raw = # lua
      ''
        function()
          local toggle = function()
            if vim.g.unhide_lualine == nil then
              vim.g.unhide_lualine = true
            end
            vim.g.unhide_lualine = not vim.g.unhide_lualine
            return vim.g.unhide_lualine
          end
          require('lualine').hide({ unhide = toggle() })
        end
      '';

    plugins = {
      lz-n = {
        enable = true;
        plugins = [
          {
            __unkeyed-1 = "unicode.vim";
            cmd = [
              "Digraphs"
              "DigraphsNew"
              "UnicodeNew"
              "UnicodeSearch"
              "UnicodeTable"
              "UnicodeCache"
            ];
          }
          {
            __unkeyed-1 = "nvim-tree.lua";
            cmd = [
              "NvimTreeToggle"
              "NvimTreeOpen"
              "NvimTreeClose"
              "NvimTreeRefresh"
              "NvimTreeFindFile"
            ];
          }
          {
            __unkeyed-1 = "typr";
            cmd = [
              "Typr"
              "TyprStats"
            ];
          }
        ];
      };

      nvim-ufo = {
        enable = true;
        lazyLoad.settings.event = "BufEnter";
        settings = {
          provider_selector = # lua
            ''
              function(bufnr, filetype, buftype)
                local ftMap = {
                  vim = "indent",
                  python = {"indent"},
                  git = "",
                  dashboard = "",
                  Avante = "",
                  AvanteSelectedFiles = "",
                  AvanteInput = "",
                }
               return ftMap[filetype]
              end
            '';

          fold_virt_text_handler = # lua
            ''
              function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ('  %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                  local chunkText = chunk[1]
                  local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                  else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if curWidth + chunkWidth < targetWidth then
                      suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                  end
                  curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, 'MoreMsg'})
                return newVirtText
              end
            '';
        };
      };

      which-key.settings.spec = [
        {
          __unkeyed-1 = "<c-n>";
          __unkeyed-2 = "<cmd>NvimTreeToggle<CR>";
          desc = "Open Tree in left side";
        }
        {
          __unkeyed-1 = "<leader>ts";
          __unkeyed-2 = "<cmd>StatusLine<cr>";
          desc = "Toggle Status Line";
        }
        {
          __unkeyed-1 = "<leader>ti";
          __unkeyed-2 = "<cmd>IBLToggle<cr>";
          desc = "Toggle Indent Blankline";
        }
        {
          __unkeyed-1 = "<leader>tc";
          __unkeyed-2 = "<cmd>ColorizerToggle<cr>";
          desc = "Toggle Colorizer";
        }
        {
          __unkeyed-1 = "<leader>tb";
          __unkeyed-2.__raw = # lua
            ''
              function()
                vim.o.background = vim.o.background == "dark" and "light" or "dark"
              end
            '';
          desc = "Toggle Dark/Light Background";
        }
      ];

      wakatime.enable = true;
      wakatime.autoLoad = false;

      image = {
        enable = true;
        lazyLoad.enable = true;
        lazyLoad.settings.ft = [
          "markdown"
          "norg"
          "typst"
        ];
        settings = {
          integrations.neorg.enabled = true;
          editor_only_render_when_focused = true;
          tmux_show_only_in_active_window = true;
        };
      };

      cord = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          display = {
            theme = "atom";
            flavor = "accent";
          };
          editor.tooltip = "Neovim";
          timestamp.reset_on_idle = true;
          idle = {
            enabled = true;
            timeout = 900000;
          };
        };
      };

      colorizer = {
        enable = true;
        lazyLoad.settings.cmd = [ "ColorizerToggle" ];
        settings = {
          user_default_options = {
            mode = "virtualtext";
            virtualtext = " ■";
            RRGGBBAA = true;
            RRGGBB = true;
            AARRGGBB = true;
          };
        };
      };

      cursorline.enable = true;

      nvim-tree = {
        enable = true;
        settings = {
          view.side = "left";
          view.width = 25;
          git.enable = true;
          filters.dotfiles = true;
        };
      };

      rainbow-delimiters.enable = true;

      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "";
          scope.enabled = true;
          scope.char = "▎";
          whitespace.highlight = [ "Whitespace" ];
          exclude.buftypes = [
            "nofile"
            "terminal"
            "neorg"
          ];
          exclude.filetypes = [
            "norg"
            "NvimTree"
            "sagaoutline"
            "help"
            "terminal"
            "dashboard"
            "lspinfo"
            "TelescopePrompt"
            "TelescopeResults"
          ];
        };
      };

      smear-cursor = {
        enable = true;
        lazyLoad.enable = true;
        lazyLoad.settings = {
          event = "InsertEnter";
          cmd = "SmearCursorToggle";
          keys = [
            {
              __unkeyed-1 = "<leader>tsc";
              __unkeyed-2 = "<cmd>SmearCursorToggle<cr>";
              desc = "Toggle Animation Cursor";
            }
          ];
        };
      };

      web-devicons = {
        enable = true;
        customIcons = {
          norg = {
            icon = "";
            color = "#389EDD";
            cterm_color = "65";
            name = "Norg";
          };
        };
      };

      bufferline.enable = true;
      lazygit.enable = true;
      which-key = {
        enable = true;
        settings = {
          win = {
            border = "rounded";
            title = true;
            title_pos = "center";
            padding = [
              1
              2
            ];
            width = 0.6;
            col = 0.5;
          };
          layout.spacing = 3;
        };
      };
      trouble.enable = true;

      lualine = {
        enable = true;
        lazyLoad.settings = {
          event = "BufEnter";
          cmd = [ "StatusLine" ];
          before.__raw = ''
            require('lsp-progress').setup()
          '';
        };
        settings = {
          # theme = "edge";
          theme = "gruvbox";
          options = {
            globalstatus = true;
            disabled_filetypes.__unkeyed-1 = "NvimTree";
            disabled_filetypes.statusline = [
              "dashboard"
              "alpha"
              "sagaoutline"
              "Trouble"
            ];
            component_separators.left = "";
            component_separators.right = "";
            section_separators.left = "";
            section_separators.right = "";
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                separator.right = "";
                padding.left = 1;
                padding.right = 1;
              }
            ];
            lualine_b = [
              {
                __unkeyed-1 = "branch";
                color.fg = "BlueSign";
              }
              "diff"
            ];
            lualine_c = [
              {
                __unkeyed-1 = "diagnostics";
                symbols = {
                  error = " ";
                  warn = " ";
                  info = " ";
                  hint = " ";
                };
              }
            ];
            lualine_x = [
              "searchcount"
              "selectioncount"
            ];
            lualine_y = [
              {
                __unkeyed-1.__raw = # lua
                  ''
                    (function()
                      local ft = require('lualine.components.filetype'):extend()
                      local lsp_progress = require('lsp-progress')

                      function ft:update_status()
                        local data = ft.super.update_status(self)
                        return lsp_progress.progress({
                          max_size = 50,
                          format = function(messages)
                              if #messages > 0 then
                                  return table.concat(messages, " ")
                              end
                              return data
                          end,
                        })
                      end

                      return ft
                    end)()
                  '';
              }
              "progress"
            ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
                separator.left = "";
                padding.right = 1;
                padding.left = 1;
              }
            ];
          };
        };
      };

    };
  };
}
