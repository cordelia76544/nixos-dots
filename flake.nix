{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    impermanence.url = "github:nix-community/impermanence";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    determinate,
    nixvim,
    nix-cachyos-kernel,
    sops-nix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };

        modules = [
          {nixpkgs.hostPlatform = "x86_64-linux";}
          determinate.nixosModules.default
          ./configuration.nix
          impermanence.nixosModules.impermanence
          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.davyjones = ./home.nix;
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
