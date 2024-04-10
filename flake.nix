{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # actualizar esto para actualizar
    unstable.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/nur";
    hm-isolation.url = "github:3442/hm-isolation";
    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11"; # actualizar esto para actualizar
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, nur, hm-isolation, nixGL, flake-utils, impermanence, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      inherit (pkgs) lib;

      base = platform: {
        name = platform;
        value = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [ 
            (import ./base) 
            impermanence.nixosModules.impermanence
          ];
        };
      };

      home = platform: {
        name = "adp@${platform}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            (import ./home {
              inherit self nixpkgs unstable hm-isolation nixGL;
            })

            ./home/platforms/${platform}.nix

            {
              config.local = { inherit platform; };
            }
          ];
        };
      };

      # localPkgs = import ./pkgs;

      platforms = domain:
        map
          (lib.removeSuffix ".nix")
          (lib.attrNames (builtins.readDir ./${domain}/platforms));

      configs = domain: builder:
        lib.listToAttrs
          (map builder (platforms domain));
    in
    {
      nixosConfigurations = configs "base" base;
      homeConfigurations = configs "home" home;
      packages.${system} = localPkgs pkgs;
      formatter.${system} = pkgs.nixpkgs-fmt;

      overlay = self: super: {
        unstable = import unstable {
          inherit (super) config system;
        };
        local = localPkgs self;
      };
    };
}
