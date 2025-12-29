{
  plugins.neo-tree = {
    enable = true;
    settings = {
      autoCleanAfterSessionRestore = true;
      closeIfLastWindow = true;
      sourceSelector = {
        winbar = true;
        statusLine = true;
      };
      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];
      addBlankLineAtTop = false;
      window = {
        width = 30;
        position = "left";
        mappings = {
          "<space>" = "toggle_node";
          "<cr>" = "open";
        };
      };

      filesystem = {
        followCurrentFile.enabled = true;
        # hijack_netrw_behavior = "open_current";
        # use_libuv_file_watcher = true;
        filteredItems = {
          hideDotfiles = false;
          hideGitignored = false;
          hideByName = [
            "node_modules"
          ];
          neverShow = [
            ".DS_Store"
            "thumbs.db"
          ];
        };
        window = {
          mappings = {
            "<2-LeftMouse>" = "open";
            "<cr>" = "open";
            "o" = "open";
            "S" = "open_split";
            "s" = "open_vsplit";
            "C" = "close_node";
            "<bs>" = "navigate_up";
            "." = "set_root";
            "H" = "toggle_hidden";
            "R" = "refresh";
            "/" = "fuzzy_finder";
            "f" = "filter_on_submit";
            "<c-x>" = "clear_filter";
            "a" = "add";
            "d" = "delete";
            "r" = "rename";
            "y" = "copy_to_clipboard";
            "x" = "cut_to_clipboard";
            "p" = "paste_from_clipboard";
            "c" = "copy";
            "m" = "move";
            "q" = "close_window";
          };
        };
      };

      buffers = {
        followCurrentFile = false;
        window = {
          mappings = {
            "bd" = "buffer_delete";
          };
        };
      };

      defaultComponentConfigs = {
        indent = {
          indentSize = 2;
          padding = 0;
          withExpanders = true;
          expanderCollapsed = "󰅂";
          expanderExpanded = "󰅀";
          expanderHighlight = "NeoTreeExpander";
          withMarkers = true;
          indentMarker = "│";
          lastIndentMarker = "└";
          highlight = "NeoTreeIndentMarker";
        };

        gitStatus = {
          symbols = {
            added = " ";
            conflict = "󰩌 ";
            deleted = "󱂥";
            ignored = " ";
            modified = " ";
            renamed = "󰑕";
            staged = "󰩍";
            unstaged = "";
            untracked = " ";
          };
        };

        name = {
          trailingSlash = false;
          useGitStatusColors = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options = {
        desc = "Open/Close Neotree";
      };
    }
  ];

}
