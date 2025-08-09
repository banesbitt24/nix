{ ... }:

{
  services.tailscale.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;
  services.dbus.enable = true;
  services.pipewire.enable = true;
  security.polkit.enable = true;
  services.upower.enable = true;
}
