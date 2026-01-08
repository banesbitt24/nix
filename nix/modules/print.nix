{ pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable color management for printers
  services.colord.enable = true;

  hardware.printers = {
    ensureDefaultPrinter = "Brother_MFC-J895DW";
    ensurePrinters = [
      {
        deviceUri = "ipp://192.168.1.107/ipp";
        location = "home";
        name = "Brother_MFC-J895DW";
        model = "everywhere";
      }
    ];
  };

  # Enable network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
