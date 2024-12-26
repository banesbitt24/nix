{ pkgs, ... }:

{
  gtk = {
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-nord.override {

    };
  };
}
