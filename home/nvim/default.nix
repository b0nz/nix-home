_:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    imports = [
      ./config
    ];
  };
}
