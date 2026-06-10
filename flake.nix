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

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:cordelia76544/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #firefox-addons = {
    #  url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #r};
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    niri,
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
          stylix.nixosModules.stylix
          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
          (
            {pkgs, ...}: {
              nixpkgs.overlays = [nix-cachyos-kernel.overlays.pinned];
              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;

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
            };
          }
        ];
      };
    };
  };
}
