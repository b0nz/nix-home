{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    typescript-tools-nvim
  ];

  extraConfigLua = ''
    require("typescript-tools").setup({
      on_attach = function(client, bufnr)
        -- Disable ts_ls formatting in favor of conform.nvim
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        -- Expose all code actions including organize imports
        expose_as_code_action = "all",
        
        -- TypeScript server preferences
        tsserver_file_preferences = {
          -- Import preferences
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          includeCompletionsWithInsertText = true,
          includeAutomaticOptionalChainCompletions = true,
          includeCompletionsWithSnippetText = true,
          includeCompletionsWithClassMemberSnippets = true,
          
          -- Auto-import settings
          includePackageJsonAutoImports = "auto",
          
          -- Display preferences (inlay hints)
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          
          -- Quote and import style
          quotePreference = "auto",
          importModuleSpecifierPreference = "relative",
          importModuleSpecifierEnding = "auto",
        },
      },
    })
  '';
}
