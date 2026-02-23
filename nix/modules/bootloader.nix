{ pkgs, ... }:

{
  # Pin to Linux 6.18 kernel (6.19 has issues)
  boot.kernelPackages = pkgs.linuxPackages_6_18;

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
    # "mitigations=off" removed - can cause kernel instability
    "amdgpu.gpu_recovery=1" # Enable automatic GPU recovery on hangs
    "amdgpu.sg_display=0" # Fix display wake issues on AMD GPUs
    "mem_sleep_default=deep" # Use deep sleep (S3) for better compatibility
  ];

  # Optimize initrd
  boot.initrd = {
    verbose = false;
    systemd.enable = true; # Use systemd in initrd for parallel processing
    kernelModules = [ "amdgpu" ]; # Early KMS for consistent Plymouth display
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
