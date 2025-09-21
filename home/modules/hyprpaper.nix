# hyprpaper.nix - Hyprpaper wallpaper daemon configuration
{ pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "/home/brandon/.nix/wallpapers/mountain_jaws.jpg"
      ];

      wallpaper = [
        ",/home/brandon/.nix/wallpapers/mountain_jaws.jpg"
      ];
    };
  };

  # Create wallpapers directory and add some default nord wallpapers
  home.file = {
    "Pictures/wallpapers/.keep".text = "";

    # You can add wallpaper files here if you have them
    # "Pictures/wallpapers/nord-landscape.jpg".source = ./path/to/your/wallpaper.jpg;
  };

  # Add wallpaper management packages
  home.packages = with pkgs; [
    hyprpaper
    waypaper # GUI wallpaper manager for Wayland
  ];
}
