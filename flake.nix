{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/nixos/bootloader.nix
          ./modules/nixos/configuration.nix
          ./modules/nixos/fonts.nix
          ./modules/nixos/keymap.nix
          ./modules/nixos/locale.nix
          ./modules/nixos/network.nix
          ./modules/nixos/packages.nix
          ./modules/nixos/plasma.nix
          ./modules/nixos/print.nix
          ./modules/nixos/services.nix
          ./modules/nixos/sound.nix
          ./modules/nixos/time.nix
          ./modules/nixos/users.nix
          ./modules/nixos/virt.nix
          ./modules/nixos/x11.nix
          inputs.distro-grub-themes.nixosModules.x86_64-linux.default
          home-manager.nixosModules.default
          {
            home-manager.backupFileExtension = "hmb";
            home-manager.sharedModules = [
              inputs.plasma-manager.homeManagerModules.plasma-manager
            ];
          }
        ];
      };
    };
}
