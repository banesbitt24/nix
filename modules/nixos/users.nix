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
      #ungoogled-chromium
      firefox
      papirus-nord
      git
      jetbrains-mono
      kdePackages.krohnkite
      nixd
      nil
      nixfmt-rfc-style
      neovim
    ];
  };
}
