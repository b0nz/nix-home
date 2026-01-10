{
  perSystem = { pkgs, ... }: {
    pre-commit = {
      check.enable = true;

      settings.hooks = {
        # 1. Nix Formatter
        nixfmt.enable = true;

        # 2. Linter: Detects unused variables
        deadnix.enable = true;

        # 3. Linter: Detects antipatterns
        statix.enable = true;

        # 4. Shell Script Linter (optional)
        shellcheck.enable = true;
        
        # 5. Lua Formatter (for your LazyVim files)
        stylua.enable = true;
      };
    };
  };
}
