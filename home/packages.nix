{ pkgs, inputs, ... }:
let
  inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
    antigravity-cli
    claude-code
    opencode
    rtk
    pi
    herdr
    ;
  # upstream versionCheckHook fails: `copilot --version` prints nothing in sandbox
  copilot-cli =
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli.overrideAttrs
      {
        doInstallCheck = false;
      };
  rea = pkgs.callPackage ./pkgs/rea { };
  claude-swap = pkgs.python3Packages.buildPythonApplication rec {
    pname = "claude-swap";
    version = "0.28.0";
    format = "pyproject";

    src = pkgs.python3Packages.fetchPypi {
      pname = "claude_swap";
      inherit version;
      hash = "sha256-0+eW7kTa3e6zQmaFlNZZUXiEaclOiHFIx47vKU1qJZM=";
      # 1. Leave empty, run `nix run` or `home-manager switch`
      # 2. It will fail and give you the correct sha256 hash. Paste it here.
    };

    nativeBuildInputs = with pkgs.python3Packages; [
      hatchling
      pythonRelaxDepsHook
    ];

    # Tell the hook to ignore textual version constraints
    pythonRelaxDeps = [
      "textual"
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      keyring
      textual
      truststore
    ];

    meta = with pkgs.lib; {
      description = "Multi-account switcher for Claude Code";
      homepage = "https://github.com/realiti4/claude-swap";
      license = licenses.mit;
      mainProgram = "cswap";
    };
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
    claude-swap
    herdr
    rea

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
