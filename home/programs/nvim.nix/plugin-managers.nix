{ pkgs, ... }:
{
  programs.nixvim = {
    # mason.nvim/mason-lspconfig.nvim themselves come from nix, but the LSP
    # servers/DAP adapters/linters they install are fetched at runtime into
    # ~/.local/share/nvim/mason — not managed or pinned by nix-home.
    extraPlugins = with pkgs.vimPlugins; [
      mason-nvim
      mason-lspconfig-nvim
    ];

    # lazy.nvim's bootstrap clone and mason.nvim's installers both shell out to git.
    extraPackages = [ pkgs.git ];

    extraConfigLua = ''
      -- Bootstrap lazy.nvim itself (outside the nix store) so it can manage
      -- ad-hoc plugins that live outside nix-home, without a rebuild.
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git", "clone", "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      -- Ad-hoc plugin specs live here, e.g. ~/.config/nvim-extra/lua/plugins/foo.lua
      -- Add/remove files there and run :Lazy sync -- no nix-home changes needed.
      local extra_dir = vim.fn.expand("~/.config/nvim-extra")
      local plugins_dir = extra_dir .. "/lua/plugins"
      vim.fn.mkdir(plugins_dir, "p")
      if #vim.fn.glob(plugins_dir .. "/*.lua", false, true) == 0 then
        local f = io.open(plugins_dir .. "/init.lua", "w")
        if f then
          f:write("-- add ad-hoc plugin specs here, or as sibling files in this directory\nreturn {}\n")
          f:close()
        end
      end
      vim.opt.rtp:prepend(extra_dir)

      require("lazy").setup({
        spec = {
          { import = "plugins" },
        },
        install = { missing = true },
        change_detection = { notify = false },
        performance = {
          -- Both default to true and reset 'runtimepath'/'packpath' to only
          -- what lazy.nvim manages, which would drop nixvim's own nix-managed
          -- plugin directory entirely.
          reset_packpath = false,
          rtp = { reset = false },
        },
      })

      -- lazy.nvim's setup() unconditionally sets loadplugins=false, which
      -- disables Neovim's native auto-loading of nixvim's nix-managed plugins
      -- (anything relying on a plain plugin/*.vim file rather than a Lua
      -- require(...).setup() call -- e.g. lazygit.nvim's :LazyGit command).
      -- Restore it and re-run packloadall so those still get sourced.
      vim.go.loadplugins = true
      vim.cmd("packloadall!")

      -- mason: ad-hoc LSP server/tool installs via :Mason, separate from the
      -- servers declared in plugins.lsp.servers above. automatic_enable
      -- calls vim.lsp.enable() itself for anything installed via :Mason.
      require("mason").setup()
      require("mason-lspconfig").setup()
    '';
  };
}
