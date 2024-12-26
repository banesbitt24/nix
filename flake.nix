{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.greywolf = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./modules/nixos/bootloader.nix
        ./modules/nixos/configuration.nix
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
        ./modules/nixos/zsh.nix
        inputs.distro-grub-themes.nixosModules.x86_64-linux.default
        home-manager.nixosModules.default
        {
          home-manager.backupFileExtension = "hmb";
        }
      ];
    };
  };
}
