{ pkgs, inputs, ... }:
let
  inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
    antigravity-cli
    claude-code
    opencode
    copilot-cli
    rtk
    ;

  inherit (inputs.serena.packages.${pkgs.stdenv.hostPlatform.system}) serena;

  themeSh = pkgs.stdenv.mkDerivation {
    name = "theme.sh";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lemnos/theme.sh/master/bin/theme.sh";
      sha256 = "606a101bdd18a101c8155a488b5506a7b219fd54005766505356d8177fdb0ff9";
    };
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/theme.sh
      chmod +x $out/bin/theme.sh
    '';
  };
in
{
  home.packages = with pkgs; [
    fastfetch
    hyfetch
    git
    wget
    curl
    unzip
    ripgrep

    # Network
    cloudflared

    # Monitoring
    btop

    # TUI
    gitui
    lazygit
    lazydocker

    # AI
    llama-cpp
    antigravity-cli
    claude-code
    opencode
    copilot-cli
    serena
    rtk

    # Editor
    vim
    obsidian

    # Shell
    fish
    fzf
    themeSh
    devenv

    # Docker
    docker
    docker-compose
  ];
}
