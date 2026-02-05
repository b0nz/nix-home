{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    folding.enable = false;
    nixvimInjections = true;
    # Use all available grammars - simpler and more robust
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };

  # Remove treesitter-textobjects configuration since it's disabled
  plugins.treesitter-textobjects = {
    enable = false;
  };
}
