{ pkgs, ... }:
let
  sslCertDir = "${pkgs.cacert}/etc/ssl/certs";
  sslCertFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  sshInit =
    if pkgs.stdenv.isDarwin then
      ''
        if set -q SSH_AUTH_SOCK
            ssh-add --apple-use-keychain ~/.ssh/id_default >/dev/null 2>&1
            ssh-add --apple-use-keychain ~/.ssh/id_work >/dev/null 2>&1
        end
      ''
    else
      ''
        if not set -q SSH_AUTH_SOCK
            eval (ssh-agent -c)
            ssh-add ~/.ssh/id_default >/dev/null 2>&1
            ssh-add ~/.ssh/id_work >/dev/null 2>&1
        end
      '';
in
{
  programs.fish = {
    enable = true;
    shellAliases = import ./aliases.nix;
    interactiveShellInit = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      export SSL_CERT_DIR=${sslCertDir}
      export SSL_CERT_FILE=${sslCertFile}

      if test (uname) = "Darwin"
          set -gx DOCKER_HOST "unix://$HOME/.colima/default/docker.sock"
      else
          set -gx DOCKER_HOST "unix:///var/run/docker.sock"
      end

      ${sshInit}

      if type -q theme.sh
          if test -e ~/.theme_history
              set -l last_theme (theme.sh -l | tail -n1)
              theme.sh $last_theme
              switch $last_theme
                  case "*gruvbox*"
                      set -gx STARSHIP_CONFIG ~/.config/starship-gruvbox.toml
                  case "*"
                      set -gx STARSHIP_CONFIG ~/.config/starship.toml
              end
          end
      end

      if status --is-interactive
      and not set -q TMUX
          exec tmux new-session -A -s sessionX
      end
    '';

    functions = {
      fish_greeting.body = "";
      th.body = ''
        theme.sh -i $argv
        set -l last_theme (theme.sh -l | tail -n1)
        switch $last_theme
            case "*gruvbox*"
                set -gx STARSHIP_CONFIG ~/.config/starship-gruvbox.toml
            case "*"
                set -gx STARSHIP_CONFIG ~/.config/starship.toml
        end
      '';
      thl.body = ''
        theme.sh --light -i $argv
        set -l last_theme (theme.sh -l | tail -n1)
        switch $last_theme
            case "*gruvbox*"
                set -gx STARSHIP_CONFIG ~/.config/starship-gruvbox.toml
            case "*"
                set -gx STARSHIP_CONFIG ~/.config/starship.toml
        end
      '';
      thd.body = ''
        theme.sh --dark -i $argv
        set -l last_theme (theme.sh -l | tail -n1)
        switch $last_theme
            case "*gruvbox*"
                set -gx STARSHIP_CONFIG ~/.config/starship-gruvbox.toml
            case "*"
                set -gx STARSHIP_CONFIG ~/.config/starship.toml
        end
      '';
    };
  };
}
