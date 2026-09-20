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

  myLib = import ../lib;
  inherit (myLib) user stateVersion;

  specialArgs = { inherit inputs user stateVersion; };
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

  flake = {
    homeConfigurations = {
      "${user}@LocaldevMac" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [ ../home ];
        extraSpecialArgs = specialArgs;
      };
    };

    nixosConfigurations = {
      LocaldevWSL = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          nixos-wsl.nixosModules.default
          sops-nix.nixosModules.sops
          ../hosts/wsl/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ../home;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      LocaldevMac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        inherit specialArgs;
        modules = [
          ../hosts/mac/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ../home;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };
  };
}
