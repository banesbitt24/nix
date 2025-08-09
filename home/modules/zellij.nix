{ ... }:

{
  programs.zellij = {
    enable = true;

    settings = {
      # Use Nord theme
      theme = "nord";

      # Default shell
      default_shell = "fish";

      # Pane frames
      pane_frames = true;

      # Auto layout
      auto_layout = true;

      # Session serialization
      session_serialization = false;

      # Copy command
      copy_command = "wl-copy";

      # Scroll buffer size
      scroll_buffer_size = 10000;

      # Mouse mode
      mouse_mode = true;

      # Simplified UI
      simplified_ui = false;

      # Default mode
      default_mode = "normal";

      # UI configuration
      ui = {
        pane_frames = {
          rounded_corners = true;
          hide_session_name = false;
        };
      };

      # Themes
      themes = {
        nord = {
          fg = "#D8DEE9";
          bg = "#2E3440";
          black = "#3B4252";
          red = "#BF616A";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#88C0D0";
          white = "#E5E9F0";
          orange = "#D08770";
        };
      };
    };
  };

}
