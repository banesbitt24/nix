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
        "~/Pictures/wallpapers/nord-landscape.jpg"
        "~/Pictures/wallpapers/nord-abstract.jpg"
      ];

      wallpaper = [
        ",~/.nix/wallpapers/mountain_jaws.jpg"
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

  # Add some useful wallpaper management packages
  home.packages = with pkgs; [
    hyprpaper
    # Useful for wallpaper management
    feh # Image viewer and wallpaper setter
    # You might also want these for wallpaper management:
    # swww  # Alternative wallpaper daemon
    # wpaperd  # Another wallpaper daemon option
  ];
}
