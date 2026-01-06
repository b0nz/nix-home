{
  perSystem =
    { config, pkgs, ... }:

    {
      devShells = {
        default = pkgs.mkShell {
          name = "dotfiles-shell";
          nativeBuildInputs = with pkgs; [
            sops
            ssh-to-age
          ];
          shellHook = ''
            echo "🛠️  Dotfiles Config Environment Active"
            ${config."pre-commit".installationScript}
          '';
        };

        # Nodejs 20 Environment
        nodejs20 = pkgs.mkShell {
          name = "nodejs20";
          packages = with pkgs; [
            nodejs_20
            nodePackages.pnpm
          ];
          shellHook = ''
            echo "🟢 Nodejs 20 Environment Active"
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };

        # Nodejs 22 Environment
        nodejs22 = pkgs.mkShell {
          name = "nodejs22";
          packages = with pkgs; [
            nodejs_22
            nodePackages.pnpm
          ];
          shellHook = ''
            echo "🟢 Nodejs 22 Environment Active"
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };

        # Nodejs 24 Environment
        nodejs24 = pkgs.mkShell {
          name = "nodejs24";
          packages = with pkgs; [
            nodejs_24
            nodePackages.pnpm
          ];
          shellHook = ''
            echo "🟢 Nodejs 24 Environment Active"
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };

        # Golang Environment
        go = pkgs.mkShell {
          name = "go";
          packages = with pkgs; [
            go
            gopls
            gotools
            golangci-lint
            delve
          ];
          shellHook = ''
            echo "🔵 Go Environment Active"
            export GOPATH="$(${pkgs.go}/bin/go env GOPATH)"
            export PATH="$PATH:$GOPATH/bin"
          '';
        };

        # Rust Environment
        rust = pkgs.mkShell {
          name = "rust";
          packages = with pkgs; [
            cargo
            rustc
            rustfmt
            rust-analyzer
            clippy
            pkg-config
            openssl
          ];
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          shellHook = ''
            echo "🦀 Rust Environment Active"
          '';
        };

        # Android Environment
        android = pkgs.mkShell {
          name = "android";
          buildInputs = with pkgs; [
            android-tools
            android-studio
            zulu17
          ];

          shellHook = ''
            export ANDROID_HOME=$HOME/Android/Sdk
            export PATH=$PATH:$ANDROID_HOME/emulator
            export PATH=$PATH:$ANDROID_HOME/platform-tools

            echo "🤖 Android Dev Environment Ready"
            echo "KVM Access: $([ -w /dev/kvm ] && echo '✅ Granted' || echo '❌ Denied (Check configuration.nix)')"
          '';
        };
      };
    };
}
