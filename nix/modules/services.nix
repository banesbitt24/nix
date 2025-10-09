{ pkgs, ... }:

{
  services.tailscale.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;
  services.fprintd.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  services.power-profiles-daemon.enable = false; # Disabled in favor of TLP
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.graphics.enable = true;

  # PAM configuration for fingerprint authentication
  security.pam.services.login.fprintAuth = true;
  security.pam.services.hyprlock = {
    fprintAuth = true;
    # Ensure hyprlock can unlock without hanging
    unixAuth = true;
  };

  # Enable polkit system service
  security.polkit.enable = true;

  # Enable GNOME keyring for credential storage
  services.gnome.gnome-keyring.enable = true;

  # Enable Docker service with optimizations
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Start Docker on-demand instead of boot
    autoPrune.enable = true;
  };

  # XDG portals for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };
}
