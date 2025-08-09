{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
  };
}
