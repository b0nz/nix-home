{ pkgs, ... }:
{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "modern";
      delay = 200;
      spec = [
        {
          __unkeyed-1 = "<leader><tab>";
          group = "tabs";
          icon = "󰓩 ";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "buffer";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "file/find";
          icon = "󰈞 ";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
          icon = "󰊢 ";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "quit/session";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "ui";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "windows";
          icon = "󰖲 ";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "diagnostics/quickfix";
          icon = "󱖫 ";
        }
      ];
      icons = {
        breadcrumb = "»";
        separator = "󰁔";
        group = "+";
      };
      win = {
        border = "rounded";
        no_overlap = false;
        padding = [
          1
          2
        ];
        title = true;
        title_pos = "center";
        zindex = 1000;
      };
      # show_keys = true;
      # show_help = true;
      # triggers = "auto";
      # triggers_blacklist = [
      #   {
      #     __unkeyed-1 = "<leader>!";
      #     mode = "n";
      #   }
      #   {
      #     __unkeyed-1 = "<leader>w";
      #     mode = "n";
      #   }
      # ];
    };
  };
}
