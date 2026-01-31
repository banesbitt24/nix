{ pkgs, ... }:

{
  # Enable fish shell system-wide
  programs.fish.enable = true;

  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
      "lp"      # Printer administration
      "scanner" # Scanner access
    ];
  };
}
