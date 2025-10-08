{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 10;
    };
    
    settings = {
      # Shell integration
      shell_integration = "enabled";
      shell = "${pkgs.fish}/bin/fish";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = "0";
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Window settings
      confirm_os_window_close = 0;
      background_opacity = "0.95";
      
      # Nord theme colors to match ghostty
      foreground = "#d8dee9";
      background = "#2e3440";
      
      # Palette colors (Nord theme)
      color0 = "#3b4252";   # black
      color1 = "#bf616a";   # red
      color2 = "#a3be8c";   # green
      color3 = "#ebcb8b";   # yellow
      color4 = "#81a1c1";   # blue
      color5 = "#b48ead";   # magenta
      color6 = "#88c0d0";   # cyan
      color7 = "#e5e9f0";   # white
      color8 = "#4c566a";   # bright black
      color9 = "#bf616a";   # bright red
      color10 = "#a3be8c";  # bright green
      color11 = "#ebcb8b";  # bright yellow
      color12 = "#81a1c1";  # bright blue
      color13 = "#b48ead";  # bright magenta
      color14 = "#8fbcbb";  # bright cyan
      color15 = "#eceff4";  # bright white
    };
  };
}

