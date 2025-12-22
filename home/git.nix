{ config, pkgs, ... }:

{
  sops.secrets.default_email = { };
  sops.secrets.work_email = { };

  sops.templates."git-personal" = {
    content = ''
      [user]
        name = b0nz
        email = ${config.sops.placeholder.default_email}
      
      [core]
        sshCommand = "ssh -i ~/.ssh/id_default"
    '';
  };

  sops.templates."git-work" = {
    content = ''
      [user]
        name = b0nz
        email = ${config.sops.placeholder.work_email}

      [core]
        sshCommand = "ssh -i ~/.ssh/id_work"
    '';
  };

  programs.git = {
    enable = true;

    # Global Configuration
    settings = {
      init.defaultBranch = "main";
    };
    includes = [
      {
        path = config.sops.templates."git-personal".path;
      }
      {
        condition = "gitdir:~/work/";
	path = config.sops.templates."git-work".path;
      }
    ];
  };
}
