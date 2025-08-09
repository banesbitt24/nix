{ pkgs, ... }:

{
  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };
}
