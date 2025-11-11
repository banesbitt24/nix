{ pkgs, ... }:

{
  # Kernel modules required for Docker
  boot.kernelModules = [
    "overlay"
    "br_netfilter"
  ];

  # Networking sysctl parameters required for Docker
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.ipv4.ip_forward" = 1;
  };

  # Mount /dev/sda1 for docker storage
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/c63be4bd-65d5-47d9-a851-bd5a649f7fed";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Create directories for docker data
  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 root root -"
    "d /mnt/storage/docker 0755 root root -"
  ];

  # Configure docker to use /dev/sda1 storage
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    daemon.settings = {
      data-root = "/mnt/storage/docker";
      storage-opts = [];
    };
  };

  # Ensure docker starts after the mount point is available
  systemd.services.docker.after = [ "mnt-storage.mount" ];
  systemd.services.docker.requires = [ "mnt-storage.mount" ];
}
