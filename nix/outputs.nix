{ inputs }:

let
  inherit (inputs)
    nixpkgs
    nixos-wsl
    nix-darwin
    home-manager
    flake-parts
    sops-nix
    ;
in
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  imports = [
    inputs.pre-commit-hooks.flakeModule

    ./dev-shells.nix
    ./pre-commit.nix
  ];

  # ==========================================
  # GLOBAL SYSTEM CONFIGURATION
  # ==========================================
  flake = {
    homeConfigurations = {
      "b0nz@LocaldevMac" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [ ../home ];
        extraSpecialArgs = { inherit inputs; };
      };
    };

    nixosConfigurations = {
      LocaldevWSL = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # The WSL Module (Replaces <nixos-wsl/modules>)
          nixos-wsl.nixosModules.default

          # SOPS for secrets management
          sops-nix.nixosModules.sops

          # System Config
          ../hosts/wsl/configuration.nix

          # Home Manager Module (Integrated into the system)
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.b0nz = import ../home;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      LocaldevMac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # or "x86_64-darwin" depending on your Mac
        modules = [
          # System Config
          ../hosts/mac/configuration.nix

          # Home Manager Module
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.b0nz = import ../home;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}
