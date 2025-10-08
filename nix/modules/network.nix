{ lib, pkgs, ... }:

{
  networking.hostName = "quicksilver"; # Define your hostname.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Explicitly disable wpa_supplicant service
  #systemd.services.wpa_supplicant.enable = false;

  # Speed up boot by disabling NetworkManager-wait-online
  systemd.services.NetworkManager-wait-online.enable = false;

  # Configure NetworkManager for faster startup
  networking.networkmanager = {
    wifi.powersave = false;
    dns = "systemd-resolved";
  };

  # Enable systemd-resolved for faster DNS
  services.resolved.enable = true;

}
