{ pkgs, ... }:

{
  # Use the Grub boot loader
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.configurationLimit = 5;

  # Boot optimization settings
  boot.loader.timeout = 5; # Boot menu timeout
  boot.kernelParams = [
    "quiet" # Reduce kernel messages
    "splash" # Enable Plymouth splash screen for LUKS prompts
    "loglevel=3" # Show only important messages
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
    "mitigations=off" # Disable CPU mitigations for faster boot (security trade-off)
  ];

  # Optimize initrd
  boot.initrd = {
    verbose = false;
    systemd.enable = true; # Use systemd in initrd for parallel processing
  };

  boot.plymouth = {
    enable = true;
    theme = "circuit";
    themePackages = with pkgs; [
      # Install only the specified theme(s)
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "circuit" ];
      })
    ];
  };

  distro-grub-themes = {
    enable = true;
    theme = "framework13";
  };

}
