{
  plugins.tailwind-sorter = {
    enable = true;
    settings = {
      on_save_enabled = true;
      on_save_pattern = [
        "*.html"
        "*.css"
        "*.scss"
        "*.js"
        "*.jsx"
        "*.ts"
        "*.tsx"
        "*.vue"
        "*.svelte"
        "*.astro"
        "*.php"
        "*.blade.php"
        "*.erb"
        "*.liquid"
      ];
      node_path = "node";
    };
  };
}
