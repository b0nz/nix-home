{ pkgs, ... }:
let
  sslCertDir = "${pkgs.cacert}/etc/ssl/certs";
  sslCertFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  sshInit =
    if pkgs.stdenv.isDarwin then
      ''
        if [ -n "$SSH_AUTH_SOCK" ]; then
            ssh-add --apple-use-keychain ~/.ssh/id_default >/dev/null 2>&1
            ssh-add --apple-use-keychain ~/.ssh/id_work >/dev/null 2>&1
        fi
      ''
    else
      ''
        if [ -z "$SSH_AUTH_SOCK" ]; then
            eval $(ssh-agent -s)
            ssh-add ~/.ssh/id_default >/dev/null 2>&1
            ssh-add ~/.ssh/id_work >/dev/null 2>&1
        fi
      '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = import ./aliases.nix;
    initExtra = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      export SSL_CERT_DIR=${sslCertDir}
      export SSL_CERT_FILE=${sslCertFile}

      if [ "$(uname)" = "Darwin" ]; then
          export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
      else
          export DOCKER_HOST="unix:///var/run/docker.sock"
      fi

      ${sshInit}

      if [ -n "$BASH_VERSION" ] && [ -z "$TMUX" ] && [ -t 1 ]; then
          exec tmux new-session -A -s sessionX
      fi
    '';
  };
}
