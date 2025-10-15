# mako.nix - Mako notification daemon configuration with Nord theme
{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    
    settings = {
      # Basic notification settings
      width = 400;
      height = 120;
      margin = "10";
      padding = "16";
      border-size = 3;
      border-radius = 4;
      
      # Font configuration matching waybar
      font = "JetBrainsMono Nerd Font 10";
      
      # Nord color scheme
      background-color = "#2e3440";
      text-color = "#eceff4";
      border-color = "#5e81ac";
      
      # Positioning
      anchor = "top-right";
      
      # Behavior
      default-timeout = 5000;
      max-visible = 5;
      
      # Icons
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      max-icon-size = 32;
    };
    
    # Urgency-specific configurations
    extraConfig = ''
      [urgency=low]
      background-color=#2e3440
      text-color=#d8dee9
      border-color=#4c566a
      default-timeout=3000
      
      [urgency=normal]
      background-color=#2e3440
      text-color=#eceff4
      border-color=#5e81ac
      default-timeout=5000
      
      [urgency=critical]
      background-color=#2e3440
      text-color=#eceff4
      border-color=#bf616a
      default-timeout=0
      
      [app-name="Spotify"]
      background-color=#2e3440
      text-color=#a3be8c
      border-color=#a3be8c
      default-timeout=3000
      
      [summary~="Volume|Audio"]
      background-color=#2e3440
      text-color=#81a1c1
      border-color=#81a1c1
      default-timeout=2000
    '';
  };
  
  # Add libnotify for notify-send command
  home.packages = with pkgs; [
    libnotify
  ];
}
