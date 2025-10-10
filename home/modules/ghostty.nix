{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    settings = {
      # Font configuration
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 12;
      font-thicken = false;

      # Theme and appearance
      background-opacity = 0.95;

      # Window settings
      window-decoration = true;
      window-title-font-family = "JetBrainsMono Nerd Font";

      # Terminal behavior
      scrollback-limit = 10000;
      confirm-close-surface = false;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;

      # Shell integration
      shell-integration = "fish";
      shell-integration-features = "cursor";

      # Default shell
      command = "${pkgs.fish}/bin/fish";

      # Colors (Nord theme compatible with Starship)
      foreground = "d8dee9";
      background = "2e3440";

      # Palette colors (Nord theme)
      palette = [
        "0=#3b4252" # black
        "1=#bf616a" # red
        "2=#a3be8c" # green
        "3=#ebcb8b" # yellow
        "4=#81a1c1" # blue
        "5=#b48ead" # magenta
        "6=#88c0d0" # cyan
        "7=#e5e9f0" # white
        "8=#4c566a" # bright black
        "9=#bf616a" # bright red
        "10=#a3be8c" # bright green
        "11=#ebcb8b" # bright yellow
        "12=#81a1c1" # bright blue
        "13=#b48ead" # bright magenta
        "14=#8fbcbb" # bright cyan
        "15=#eceff4" # bright white
      ];

      # Key bindings
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+zero=reset_font_size"
        "ctrl+shift+n=new_window"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_surface"
        "ctrl+shift+q=quit"
      ];
    };
  };

  # Ensure Ghostty is available in the user environment
  home.packages = with pkgs; [
    ghostty
  ];
}
