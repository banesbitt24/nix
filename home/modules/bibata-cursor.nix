# bibata-cursor.nix
{ config, pkgs, ... }:

{
  # Simple cursor configuration
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  # Session variables
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "16";
  };

  # Install cursor package
  home.packages = with pkgs; [
    bibata-cursors
  ];
}

