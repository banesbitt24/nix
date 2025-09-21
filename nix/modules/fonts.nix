{ pkgs, ... }:

{
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.jetbrains-mono
    pkgs.ubuntu_font_family
  ];
}
