{
  perSystem = { config, pkgs, inputs', ... }: {
    devShells = {
      default = pkgs.mkShell {
        name = "dotfiles-shell";
	nativeBuildInputs = with pkgs; [
	  sops
	  ssh-to-age
	];
        shellHook = ''
          echo "🛠️  Dotfiles Config Environment Active"
          ${config.pre-commit.installationScript} 
        '';
      };

      # Next.js / Node Environment
      nextjs = pkgs.mkShell {
        name = "nextjs-env";
        packages = with pkgs; [
          nodejs_20
          nodePackages.pnpm
        ];
        shellHook = ''
          echo "🟢 Next.js (Node 20) Environment Active"
          export PATH="$PWD/node_modules/.bin:$PATH"
        '';
      };

      # Golang Environment
      go = pkgs.mkShell {
        name = "go-env";
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
        name = "rust-env";
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
    };
  };
}
