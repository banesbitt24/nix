{ pkgs, ... }:

{
  # Enable Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    remember_owner = 0
  '';
  programs.virt-manager.enable = true;

  # Ensure the default network autostarts
  systemd.services.libvirtd-autostart-default-network = {
    description = "Autostart libvirt default network";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.libvirt}/bin/virsh net-autostart default";
      User = "root";
    };
  };
}
