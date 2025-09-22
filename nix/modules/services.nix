{ pkgs, ... }:

{
  services.tailscale.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;
  services.fprintd.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  services.power-profiles-daemon.enable = true;
  #hardware.bluetooth.enable = true;
  #hardware.graphics.enable = true;

  # PAM configuration for fingerprint authentication
  # Uncomment these lines to enable fingerprint for login and hyprlock
  # security.pam.services.login.fprintAuth = true;
  # security.pam.services.hyprlock.fprintAuth = true;

  # Enable polkit system service
  security.polkit.enable = true;

  # Enable GNOME keyring for credential storage
  services.gnome.gnome-keyring.enable = true;

  # Enable Docker service
  virtualisation.docker.enable = true;

  # XDG portals for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}
