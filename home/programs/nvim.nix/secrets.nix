{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.nvim-sops ];

    extraConfigLuaPost = "require('nvim_sops').setup()";
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-sops";
        cmd = [
          "SopsDecrypt"
          "SopsEncrypt"
        ];
      }
    ];
  };
}
