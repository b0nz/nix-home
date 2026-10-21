{ pkgs, inputs, ... }:
let
  inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
    antigravity-cli
    claude-code
    opencode
    rtk
    pi
    command-code
    ;
  # upstream versionCheckHook fails: `copilot --version` prints nothing in sandbox
  copilot-cli =
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli.overrideAttrs
      {
        doInstallCheck = false;
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
    rtk
    pi
    command-code

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
