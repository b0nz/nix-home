{ pkgs, ... }:
{
  programs.nixvim = {
    autoCmd = [
      {
        # Disable cmp in neorepl
        event = [ "FileType" ];
        pattern = "neorepl";
        callback.__raw = # lua
          ''
            function()
              require("cmp").setup.buffer { enabled = false }
            end
          '';
      }
    ];

    extraPlugins = [
      pkgs.vimPlugins.claudecode-nvim
    ];

    plugins = {
      lz-n.plugins = [
        {
          __unkeyed-1 = pkgs.vimPlugins.claudecode-nvim.name;
          cmd = [
            "ClaudeCode"
            "ClaudeCodeFocus"
            "ClaudeCodeDiffDeny"
            "ClaudeCodeDiffAccept"
          ];
          after.__raw = # lua
            ''
              function()
                require("claudecode").setup({
                    terminal = {
                    split_side = "right", -- "left" or "right"
                    split_width_percentage = 0.30,
                    provider = "native", -- "auto", "snacks", or "native"
                    auto_close = true,
                    snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()`
                  },
                })
              end
            '';
        }
      ];

      avante = {
        enable = true;
        lazyLoad.enable = true;
        lazyLoad.settings.cmd = [
          "AvanteAsk"
          "AvanteBuild"
          "AvanteChat"
          "AvanteEdit"
          "AvanteFocus"
          "AvanteRefresh"
          "AvanteSwitchProvider"
          "AvanteShowRepoMap"
          "AvanteToggle"
        ];
        settings = {
          provider = "claude";

          diff = {
            autojump = true;
            debug = false;
            list_opener = "copen";
          };

          highlights = {
            diff = {
              current = "GitConflictAncestor";
              incoming = "GitConflictIncoming";
            };
          };

          hints = {
            enabled = true;
          };

          claude = {
            endpoint = "https://api.anthropic.com";
            model = "claude-sonnet-5";
            temperature = 0.7;
            max_tokens = 20000;
          };
        };
      };

      copilot-lua.enable = false;

      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>ta";
          __unkeyed-2 = "<cmd>AvanteToggle<cr>";
          icon = " ";
          desc = "Toggle Avante";
        }
        {
          __unkeyed-1 = "<leader>ca";
          __unkeyed-2 = "<cmd>AvanteAsk<cr>";
          icon = " ";
          desc = "Open AI Ask";
        }
        {
          __unkeyed-1 = "<leader>cc";
          __unkeyed-2 = "<cmd>AvanteChat<cr>";
          icon = " ";
          desc = "Open AI Chat";
        }
        {
          __unkeyed-1 = "<leader>ce";
          __unkeyed-2 = "<cmd>AvanteEdit<cr>";
          icon = " ";
          desc = "Edit with instruction";
        }
      ];
    };
  };
}
