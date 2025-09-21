{ pkgs, ... }:

{
  # Enable SANE for scanning Brother MFC-J895DW
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      # Brother scanner support via network discovery
      sane-airscan    # Network scanners via eSCL/AirScan/WSD (works with Brother)
    ];
  };

  # Add scanning support packages
  environment.systemPackages = with pkgs; [
    simple-scan          # GNOME document scanner (optimal for Hyprland)
  ];

  # Ensure scanner group exists
  users.groups.scanner = { };
}