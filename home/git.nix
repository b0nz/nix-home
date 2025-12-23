{ config, ... }:

{
  sops = {
    secrets.default_email = { };
    secrets.work_email = { };

    templates."git-personal" = {
      content = ''
        [user]
          name = b0nz
          email = ${config.sops.placeholder.default_email}

        [core]
          sshCommand = "ssh -i ~/.ssh/id_default"
      '';
    };

    templates."git-work" = {
      content = ''
        [user]
          name = b0nz
          email = ${config.sops.placeholder.work_email}

        [core]
          sshCommand = "ssh -i ~/.ssh/id_work"
      '';
    };
  };

  programs.git = {
    enable = true;

    # Global Configuration
    settings = {
      init.defaultBranch = "main";
    };
    includes = [
      {
        inherit (config.sops.templates."git-personal") path;
      }
      {
        condition = "gitdir:~/work/";
        inherit (config.sops.templates."git-work") path;
      }
    ];
  };
}
