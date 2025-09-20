{ config, pkgs, ... }:

{
  # GTK theme configuration for all GTK apps (including thunar)
  gtk = {
    enable = true;
    
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-nord;
    };
    
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Environment variables for GTK theme
  home.sessionVariables = {
    GTK_THEME = "Nordic";
  };

  # Configure theme settings via dconf for better compatibility
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Nordic";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      color-scheme = "prefer-dark";
    };
  };
}