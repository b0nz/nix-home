_: {
  programs.nixvim.plugins = {
    telescope.enable = true;

    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [
          "bash"
          "html"
          "javascript"
          "json"
          "lua"
          "markdown"
          "markdown_inline"
          "nix"
          "python"
          "query"
          "regex"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];
      };
    };

    # LSP servers and cmp are configured in ./lsp.nix
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    luasnip.enable = true;
    friendly-snippets.enable = true;

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          python = [ "black" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          json = [ "prettier" ];
          markdown = [ "prettier" ];
        };
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
      };
    };

    comment.enable = true;
    nvim-autopairs.enable = true;
    flash.enable = true;
    todo-comments.enable = true;
  };
}
