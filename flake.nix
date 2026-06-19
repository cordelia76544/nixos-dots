{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    stylix.url = "github:nix-community/stylix/release-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:cordelia76544/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    impermanence,
    nix-cachyos-kernel,
    nixvim,
    helium,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          inherit inputs;
        };

        modules = [
          {nixpkgs.hostPlatform = "x86_64-linux";}
          ./configuration.nix
          impermanence.nixosModules.impermanence
          stylix.nixosModules.stylix
          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
          (
            {pkgs, ...}: {
              nixpkgs.overlays = [nix-cachyos-kernel.overlays.pinned];
              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;

              nix.settings.substituters = ["https://attic.xuyh0120.win/lantian"];
              nix.settings.trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
            }
          )

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.davyjones = ./home.nix;
              extraSpecialArgs = {inherit inputs;};
              #sharedModules = [
              #  impermanence.homeManagerModules.impermanence
              #];
            };
          }
        ];
      };
    };
  };
}
