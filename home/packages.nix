{ pkgs, inputs, ... }:
let
  inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
    antigravity-cli
    claude-code
    opencode
    copilot-cli
    rtk
    ;
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
    rtk

    # Editor
    vim
    obsidian

    # Shell
    fish
    fzf
    devenv

    # Docker
    docker
    docker-compose
  ];
}
