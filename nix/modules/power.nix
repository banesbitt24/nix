# power.nix - Power management and hibernation configuration
{ config, pkgs, ... }:

{
  # Enable hibernation support
  boot.resumeDevice = "/dev/mapper/luks-swap";
  
  # Power management settings
  # Let Hyprland/hypridle handle lid events to avoid conflicts
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";  # Don't let systemd-logind handle the lid
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandlePowerKey = "poweroff";
      IdleAction = "ignore";
    };
  };

  # Enable swap for hibernation
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;  # Prefer RAM over swap for better performance
  };

  # Additional power management
  services.tlp = {
    enable = true;
    settings = {
      # Battery settings
      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Enable hibernate on low battery
      RESTORE_DEVICE_STATE_ON_STARTUP = 1;

      # Prevent USB autosuspend from disabling the fingerprint reader
      # Framework laptop Goodix fingerprint reader
      USB_DENYLIST = "27c6:609c 27c6:639c";
    };
  };
}