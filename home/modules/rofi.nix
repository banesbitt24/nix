# rofi.nix - Rofi-wayland configuration with Nord theme
{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    font = "JetBrainsMono Nerd Font 12";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      disable-history = false;
      sidebar-mode = false;
      hover-select = true;
      eh = 1;
      auto-select = false;
      parse-hosts = false;
      parse-known-hosts = false;
      combi-modi = "drun,run";
      matching = "fuzzy";
      sort = true;
      threads = 0;
      scroll-method = 0;
      window-thumbnail = false;
    };

    theme = "~/.config/rofi/nord.rasi";
  };

  home.file.".config/rofi/nord.rasi" = {
    text = ''
      * {
          nord0: #2e3440;
          nord1: #3b4252;
          nord2: #434c5e;
          nord3: #4c566a;
          nord4: #d8dee9;
          nord5: #e5e9f0;
          nord6: #eceff4;
          nord7: #8fbcbb;
          nord8: #88c0d0;
          nord9: #81a1c1;
          nord10: #5e81ac;
          nord11: #bf616a;
          nord12: #d08770;
          nord13: #ebcb8b;
          nord14: #a3be8c;
          nord15: #b48ead;

          background-color: transparent;
          text-color: @nord6;
          font: "JetBrainsMono Nerd Font 12";
      }

      window {
          background-color: @nord0;
          border: 3px;
          border-color: @nord10;
          border-radius: 4px;
          padding: 0px;
          width: 600px;
          location: center;
          anchor: center;
      }

      mainbox {
          background-color: transparent;
          children: [ inputbar, listview ];
          padding: 16px;
          spacing: 16px;
      }

      inputbar {
          background-color: @nord0;
          text-color: @nord6;
          border-radius: 0px;
          padding: 12px 16px;
          spacing: 12px;
          children: [ prompt, entry ];
      }

      prompt {
          background-color: transparent;
          text-color: @nord9;
      }

      entry {
          background-color: transparent;
          text-color: @nord6;
          placeholder: "Search...";
          placeholder-color: @nord3;
          cursor: text;
      }

      listview {
          background-color: transparent;
          columns: 1;
          lines: 8;
          cycle: true;
          dynamic: true;
          scrollbar: false;
          layout: vertical;
          reverse: false;
          fixed-height: true;
          fixed-columns: true;
          spacing: 2px;
          padding: 0px;
      }

      element {
          background-color: transparent;
          text-color: @nord6;
          orientation: horizontal;
          border-radius: 0px;
          padding: 8px 12px;
          spacing: 12px;
          border: 0px;
      }

      element-icon {
          background-color: transparent;
          size: 24px;
          cursor: inherit;
      }

      element-text {
          background-color: transparent;
          text-color: inherit;
          cursor: inherit;
          vertical-align: 0.5;
          horizontal-align: 0.0;
      }

      element selected {
          background-color: @nord10;
          text-color: @nord6;
      }

      element alternate {
          background-color: transparent;
      }
    '';
  };
}
