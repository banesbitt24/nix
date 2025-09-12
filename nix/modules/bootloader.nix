{ ... }:

{
  # Use the Grub boot loader
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.configurationLimit = 5;

  distro-grub-themes = {
    enable = true;
    theme = "framework13";
  };

}
