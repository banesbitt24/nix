{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;
    
    # Configure individual applications using configFile
    configFile = {
      # Krohnkite specific configuration
      "kwinrc"."Script-krohnkite" = {
        screenGapBetween = 5;
        screenGapBottom = 10;
        screenGapLeft = 10;
        screenGapRight = 10;
        screenGapTop = 18;
      };
      
      "kwinrc"."Plugins" = {
        krohnkiteEnabled = true;
      };
      
      "kwinrc"."Tiling" = {
        padding = 4;
      };
      
      # Additional KWin settings
      "kwinrc"."Xwayland" = {
        Scale = 1;
      };
      
      # Virtual desktop configuration
      "kwinrc"."Desktops" = {
        Number = 1;
        Rows = 1;
      };
    };
  };
  
  # Additional KDE packages that might be useful
  home.packages = with pkgs; [
    kdePackages.krohnkite
  ];
}