{ pkgs, ... }:

{
  gtk = {
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme.override {
      folderColor = "frostblue3";
      iconTheme = "Papirus-Dark";
      theme = "Papirus-Dark";
    };
  };
}
