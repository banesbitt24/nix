{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
      brave
      papirus-nord
      git
      zsh
      jetbrains-mono
      enpass
      gimp-with-plugins
      kdePackages.krohnkite
      nerdfonts
      zed-editor
      nixd
      nil
      neovim
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-powerlevel10k
      kdenlive
    ];
  };

  users.extraUsers.danielle = {
    isNormalUser = true;
    description = "Danielle";
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      google-chrome
    ];
  };
}
