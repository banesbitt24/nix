{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [
      brave
      papirus-nord
      git
      jetbrains-mono
      enpass
      gimp-with-plugins
      kdePackages.krohnkite
      nerdfonts
      zed-editor
      nixd
      nil
      nixfmt-rfc-style
      neovim
      kdenlive
      obsidian
    ];
  };

  users.extraUsers.danielle = {
    isNormalUser = true;
    description = "Danielle";
    extraGroups = [
      "networkmanager"
      "wheel"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      google-chrome
    ];
  };
}
