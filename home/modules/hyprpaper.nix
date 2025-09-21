# hyprpaper.nix - Hyprpaper wallpaper daemon configuration
{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.nix/wallpapers/mountain_jaws.jpg"
      ];

      wallpaper = [
        "eDP-1,~/.nix/wallpapers/mountain_jaws.jpg"
      ];
    };
  };

  # Create wallpapers directory and add some default nord wallpapers
  home.file = {
    "Pictures/wallpapers/.keep".text = "";

    # You can add wallpaper files here if you have them
    # "Pictures/wallpapers/nord-landscape.jpg".source = ./path/to/your/wallpaper.jpg;
  };

  # Ensure hyprpaper starts with hyprland
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper"
    ];
  };

  # Add wallpaper management packages
  home.packages = with pkgs; [
    hyprpaper
    waypaper  # GUI wallpaper manager for Wayland
    feh       # Image viewer and wallpaper setter
  ];
}
