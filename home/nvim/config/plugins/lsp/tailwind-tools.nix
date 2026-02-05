{
  plugins.tailwind-tools = {
    enable = true;
    settings = {
      server = {
        override = true;
      };
      document_color = {
        enabled = true;
        kind = "inline";
        inline_symbol = "󰝤 ";
        debounce = 200;
      };
      conceal = {
        enabled = false;
      };
      cmp = {
        highlight = "foreground";
      };
    };
  };

  extraConfigLua = ''
    -- Auto-sort Tailwind classes on save for supported filetypes
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.html", "*.css", "*.scss", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte" },
      callback = function()
        -- Check if tailwind-tools is available and sort classes
        local ok, tailwind_tools = pcall(require, "tailwind-tools")
        if ok then
          vim.cmd("TailwindSort")
        end
      end,
    })
  '';
}
