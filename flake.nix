{
  description = "Brandon's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }@inputs:
  {
    nixosConfigurations.quicksilver = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nix/configuration.nix
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        inputs.distro-grub-themes.nixosModules.x86_64-linux.default
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmb";
          home-manager.users.brandon = import ./home/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
