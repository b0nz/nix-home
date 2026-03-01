{
  autoGroups = {
    highlight_yank = { };
    vim_enter = { };
    indentscope = { };
    restore_cursor = { };
    auto_organize_imports = { };
  };

  autoCmd = [
    {
      group = "highlight_yank";
      event = [ "TextYankPost" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      };
    }
    {
      group = "vim_enter";
      event = [ "VimEnter" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.cmd('Startup')
          end
        '';
      };
    }
    {
      group = "indentscope";
      event = [ "FileType" ];
      pattern = [
        "help"
        "Startup"
        "startup"
        "neo-tree"
        "Trouble"
        "trouble"
        "notify"
      ];
      callback = {
        __raw = ''
          function()
            vim.b.miniindentscope_disable = true
          end
        '';
      };
    }
    ## from NVChad https://nvchad.com/docs/recipes (this autocmd will restore the cursor position when opening a file)
    {
      group = "restore_cursor";
      event = [ "BufReadPost" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            if
              vim.fn.line "'\"" > 1
              and vim.fn.line "'\"" <= vim.fn.line "$"
              and vim.bo.filetype ~= "commit"
              and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
            then
              vim.cmd "normal! g`\""
            end
          end
        '';
      };
    }
    ## Auto-organize imports on save for supported languages
    {
      group = "auto_organize_imports";
      event = [ "BufWritePre" ];
      pattern = [
        "*.ts"
        "*.tsx"
        "*.js"
        "*.jsx"
        "*.go"
        "*.py"
      ];
      callback = {
        __raw = ''
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            for _, client in ipairs(clients) do
              -- TypeScript/JavaScript: organize imports via typescript-tools
              if client.name == "typescript-tools" then
                vim.cmd("TSToolsOrganizeImports")
                break
              -- Go: organize imports via gopls
              elseif client.name == "gopls" then
                local params = vim.lsp.util.make_range_params()
                params.context = {only = {"source.organizeImports"}}
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                if result then
                  for _, res in pairs(result) do
                    for _, action in pairs(res.result or {}) do
                      if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                      end
                    end
                  end
                end
                break
              -- Python: organize imports via pyright
              elseif client.name == "pyright" then
                local params = vim.lsp.util.make_range_params()
                params.context = {only = {"source.organizeImports"}}
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                if result then
                  for _, res in pairs(result) do
                    for _, action in pairs(res.result or {}) do
                      if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                      end
                    end
                  end
                end
                break
              end
            end
          end
        '';
      };
    }
  ];
}
