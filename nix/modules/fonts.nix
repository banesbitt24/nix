{ pkgs, ... }:

{
  fonts = {
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.jetbrains-mono
      pkgs.ubuntu_font_family
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
