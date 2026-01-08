{ pkgs, ... }:

{
  # Additional kernel modules for k3s (docker.nix already has overlay and br_netfilter)
  boot.kernelModules = [
    "nf_conntrack"
  ];

  # Additional sysctl for k3s (docker.nix already has IPv4 settings)
  boot.kernel.sysctl = {
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

  # Create directories for k3s data (docker.nix already creates /mnt/storage and /mnt/storage/docker)
  systemd.tmpfiles.rules = [
    "d /mnt/storage/k3s 0755 root root -"
    "d /mnt/storage/k3s/server 0755 root root -"
    "d /mnt/storage/k3s/agent 0755 root root -"
  ];

  # Enable k3s with Docker runtime support
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      # Use custom data directory on /mnt/storage
      "--data-dir=/mnt/storage/k3s"
      # Use Docker as container runtime
      "--docker"
      # Disable traefik to avoid conflicts
      "--disable=traefik"
      # Set cluster CIDR
      "--cluster-cidr=10.244.0.0/16"
      # Write kubeconfig with correct permissions
      "--write-kubeconfig-mode=644"
    ];
  };

  # Ensure k3s starts after the mount point and docker are available
  systemd.services.k3s = {
    after = [ "mnt-storage.mount" "docker.service" ];
    requires = [ "mnt-storage.mount" "docker.service" ];
  };

  # Add k3s to system packages
  environment.systemPackages = with pkgs; [
    k3s
  ];

  # Set KUBECONFIG environment variable for easier access
  environment.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
