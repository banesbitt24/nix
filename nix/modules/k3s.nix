{ pkgs, ... }:

{
  # Mount /dev/sda1 for k3s and docker storage
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/c63be4bd-65d5-47d9-a851-bd5a649f7fed";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Create directories for k3s and docker data
  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 root root -"
    "d /mnt/storage/k3s 0755 root root -"
    "d /mnt/storage/docker 0755 root root -"
    "d /mnt/storage/k3s/server 0755 root root -"
    "d /mnt/storage/k3s/agent 0755 root root -"
  ];

  # Enable k3s
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      # Use custom data directory on /dev/sda1
      "--data-dir=/mnt/storage/k3s"
      # Disable traefik to avoid conflicts (you can enable if needed)
      "--disable=traefik"
      # Write kubeconfig with correct permissions
      "--write-kubeconfig-mode=644"
      # Specify flannel interface (WiFi) - k3s will auto-detect IP from this interface
      "--flannel-iface=wlp192s0"
      # Bind to all addresses to handle IP changes
      "--bind-address=0.0.0.0"
    ];
  };

  # Configure docker to use /dev/sda1 storage
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    daemon.settings = {
      data-root = "/mnt/storage/docker";
    };
  };

  # Ensure k3s starts after the mount point is available
  systemd.services.k3s.after = [ "mnt-storage.mount" ];
  systemd.services.k3s.requires = [ "mnt-storage.mount" ];

  # Ensure docker starts after the mount point is available
  systemd.services.docker.after = [ "mnt-storage.mount" ];
  systemd.services.docker.requires = [ "mnt-storage.mount" ];

  # Add kubectl completion and k3s utilities to environment
  environment.systemPackages = with pkgs; [
    k3s
  ];

  # Set KUBECONFIG environment variable for easier access
  environment.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
