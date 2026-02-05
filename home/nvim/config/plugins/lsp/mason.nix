{ pkgs, ... }:
{
  plugins = {
    mason = {
      enable = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    mason-lspconfig-nvim
    mason-tool-installer-nvim
  ];

  extraConfigLua = ''
    -- Setup Mason with UI configuration
    require('mason').setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Setup mason-lspconfig with automatic installation
    require('mason-lspconfig').setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "gopls",
        "terraformls",
        "jsonls",
        "yamlls",
        "tailwindcss",
        "marksman",
        "helm_ls",
        "html",
      },
      automatic_installation = true,
    })

    -- Setup mason-tool-installer for formatters and linters
    require('mason-tool-installer').setup({
      ensure_installed = {
        "prettier",
        "prettierd",
        "black",
        "isort",
        "stylua",
        "nixfmt",
        "jq",
        "shfmt",
        "shellcheck",
        "shellharden",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    })
  '';
}
