{ pkgs, ... }:
{
  # nvim-ts-autotag - Auto close and auto rename HTML tags using treesitter
  extraPlugins = with pkgs.vimPlugins; [
    nvim-ts-autotag
  ];

  extraConfigLua = ''
    require('nvim-ts-autotag').setup({
      opts = {
        -- Enable auto close tags
        enable_close = true,
        -- Enable auto rename pairs of tags (key feature for HTML/JSX/TSX)
        enable_rename = true,
        -- Auto close on trailing </
        enable_close_on_slash = false
      },
      -- File types where auto-tag should work
      -- Using defaults which include: html, xml, jsx, tsx, vue, svelte, astro, php, markdown, etc.
      -- Uncomment and customize per_filetype if you need specific behavior
      -- per_filetype = {
      --   ["html"] = {
      --     enable_close = true,
      --     enable_rename = true
      --   }
      -- }
    })
  '';
}
