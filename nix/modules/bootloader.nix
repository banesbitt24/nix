{ pkgs, ... }:

{
  # Use the Grub boot loader
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.configurationLimit = 5;

  boot.plymouth = {
    enable = true;
    theme = "black_hud";
    themePackages = with pkgs; [
      # Install only the specified theme(s)
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "black_hud" ];
      })
    ];
  };

  distro-grub-themes = {
    enable = true;
    theme = "framework13";
  };

}
