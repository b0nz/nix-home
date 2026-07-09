{
  perSystem =
    {
      config,
      pkgs,
      lib,
      inputs',
      ...
    }:
    let
      legacyPkgs = inputs'.nixpkgs-legacy.legacyPackages;
    in
    {
      devShells = {
        default = pkgs.mkShell {
          name = "dotfiles-shell";
          nativeBuildInputs = with pkgs; [
            fish
            sops
            ssh-to-age
          ];
          shellHook = ''
            echo "🛠️  Dotfiles Config Environment Active"
            ${config."pre-commit".installationScript}
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Nodejs 20 Environment
        nodejs20 = pkgs.mkShell {
          name = "nodejs20";
          packages =
            with pkgs;
            [
              fish
            ]
            ++ [
              legacyPkgs.nodejs_20
              legacyPkgs.pnpm
              legacyPkgs.bun
            ];
          shellHook = ''
            echo "🟢 Nodejs 20 Environment Active"
            export PATH="$PWD/node_modules/.bin:$PATH"
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Nodejs 22 Environment
        nodejs22 = pkgs.mkShell {
          name = "nodejs22";
          packages = with pkgs; [
            fish
            nodejs_22
            pnpm
          ];
          shellHook = ''
            echo "🟢 Nodejs 22 Environment Active"
            export PATH="$PWD/node_modules/.bin:$PATH"
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Nodejs 24 Environment
        nodejs24 = pkgs.mkShell {
          name = "nodejs24";
          packages = with pkgs; [
            fish
            nodejs_24
            pnpm
          ];
          shellHook = ''
            echo "🟢 Nodejs 24 Environment Active"
            export PATH="$PWD/node_modules/.bin:$PATH"
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Golang Environment
        go = pkgs.mkShell {
          name = "go";
          packages = with pkgs; [
            fish
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
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Rust Environment
        rust = pkgs.mkShell {
          name = "rust";
          packages = with pkgs; [
            fish
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
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Pentest Environment
        pentest = pkgs.mkShell {
          name = "pentest";
          packages =
            with pkgs;
            [
              fish

              # Recon & Scanning
              nmap
              masscan
              rustscan
              naabu
              subfinder
              httpx
              dnsrecon
              dnsenum

              # Web Testing
              ffuf
              gobuster
              nikto
              sqlmap
              whatweb
              wfuzz

              # OSINT
              theharvester
              amass
              sherlock

              # Exploit & Cracking
              john
              hashcat

              # Utility
              netcat-gnu
              curl
              jq
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              hydra
              proxychains
            ];
          shellHook = ''
            echo "🛡️  Pentest Environment Active"
            exec ${pkgs.fish}/bin/fish
          '';
        };

        # Android Environment
        android =
          let
            androidPkgs = import pkgs.path {
              inherit (pkgs) system;
              config.allowUnfree = true;
            };
          in
          androidPkgs.mkShell {
            name = "android";
            buildInputs = with androidPkgs; [
              fish
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
              exec ${pkgs.fish}/bin/fish
            '';
          };
      };
    };
}
