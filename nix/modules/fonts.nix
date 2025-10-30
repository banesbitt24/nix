{ pkgs, ... }:

{
  fonts = {
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.jetbrains-mono
      pkgs.ubuntu-classic
    ];
    
    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };
  };
}
