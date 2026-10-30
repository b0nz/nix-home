{ config, pkgs, ... }:
{
  sops.secrets = {
    ssh_id_default = {
      path = "${config.home.homeDirectory}/.ssh/id_default";
      mode = "0600";
    };
    ssh_id_work = {
      path = "${config.home.homeDirectory}/.ssh/id_work";
      mode = "0600";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        UseKeychain = "yes";
      };
    };
  };
}
