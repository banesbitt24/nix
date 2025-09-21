{ pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # Brother drivers for MFC-J895DW
      brlaser              # Brother laser printer driver
      brgenml1lpr          # Brother Generic ML1 LPR driver
      brgenml1cupswrapper  # Brother Generic ML1 CUPS wrapper
      gutenprint           # Universal driver (fallback for Brother inkjet)
    ];
  };

  # Enable network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Install printer management tools
  environment.systemPackages = with pkgs; [
    system-config-printer  # GUI printer configuration
  ];
}
