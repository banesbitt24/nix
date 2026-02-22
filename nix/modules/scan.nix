{ pkgs, ... }:

{
  # Enable SANE for scanning Brother MFC-J895DW
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices = {
        mfc-j895dw = {
          model = "MFC-J895DW";
          ip = "192.168.1.107";  # Use same IP as printer
        };
      };
    };
    extraBackends = with pkgs; [
      sane-airscan    # Fallback driverless scanning
    ];
  };

  # Add scanning support packages
  environment.systemPackages = with pkgs; [
    simple-scan          # GNOME document scanner
    sane-frontends       # Additional SANE utilities including scanimage
  ];

  # Add user to scanner group
  users.users.brandon.extraGroups = [ "scanner" "lp" ];
}
