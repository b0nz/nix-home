{
  pkgs,
  inputs,
  config,
  user,
  stateVersion,
  ...
}:
{
  home = {
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
    stateVersion = stateVersion.home;
    sessionVariables = {
      SHELL = "${pkgs.fish}/bin/fish";
    };
  };

  imports = [
    inputs.sops-nix.homeModules.sops
    ./packages.nix
    ./shell
    ./programs/ssh.nix
    ./programs/direnv.nix
    ./appearance
    ./git.nix
    ./tmux.nix
    ./platform/darwin.nix
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_default" ];

  programs = {
    home-manager.enable = true;

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    bat = {
      enable = true;
      config.theme = "Dracula";
    };
  };
}
