{ pkgs, ... }:

{
  fonts.packages = [
    #pkgs.nerd-fonts.FiraCode
    #pkgs.nerd-fonts.JetBrainsMono
    pkgs.jetbrains-mono
  ];
}
