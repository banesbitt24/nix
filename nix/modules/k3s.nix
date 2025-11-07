{ pkgs, ... }:

{
  # Ensure required kernel modules for k3s networking
  boot.kernelModules = [
    "br_netfilter"
    "overlay"
    "nf_conntrack"
  ];

  # Networking sysctl parameters required for k3s
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Configure firewall for k3s
  networking.firewall = {
    # Allow k3s API server
    allowedTCPPorts = [ 6443 ];
    # Trust traffic from pod network and flannel
    trustedInterfaces = [ "cni0" "flannel.1" ];
    # Allow pod to host communication
    extraCommands = ''
      # Allow traffic from pod network to host
      iptables -A INPUT -s 10.244.0.0/16 -j ACCEPT
      # Allow forwarding for pod traffic
      iptables -A FORWARD -s 10.244.0.0/16 -j ACCEPT
      iptables -A FORWARD -d 10.244.0.0/16 -j ACCEPT
    '';
  };

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

  # Enable k3s with default Flannel CNI
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      # Use custom data directory on /dev/sda1
      "--data-dir=/mnt/storage/k3s"
      # Disable traefik to avoid conflicts
      "--disable=traefik"
      # Set cluster CIDR
      "--cluster-cidr=10.244.0.0/16"
      # Write kubeconfig with correct permissions
      "--write-kubeconfig-mode=644"
      # Specify node IP from WiFi interface
      "--node-ip=192.168.1.118"
    ];
  };

  # Configure docker to use /dev/sda1 storage
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    daemon.settings = {
      data-root = "/mnt/storage/docker";
      # Remove legacy overlay2.override_kernel_check option
      storage-opts = [];
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
