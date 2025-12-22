{ inputs }:

let
  inherit (inputs)
    nixpkgs
    nixos-wsl
    home-manager
    flake-parts
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

    ../dev-shells.nix
    ../pre-commit.nix
  ];

  # ==========================================
  # GLOBAL SYSTEM CONFIGURATION
  # ==========================================
  flake = {
    nixosConfigurations = {
      localdevWSL = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # The WSL Module (Replaces <nixos-wsl/modules>)
          nixos-wsl.nixosModules.default

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
    };
  };
}
