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

  hardware.printers = {
    ensureDefaultPrinter = "Brother_MFC-J895DW";
    ensurePrinters = [
      {
        deviceUri = "ipp://192.168.1.111/ipp";
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
