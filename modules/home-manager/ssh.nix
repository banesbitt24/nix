{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    
    # SSH client configuration
    extraConfig = ''
      # Use modern SSH settings
      Host *
        # Prefer modern algorithms
        KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512
        HostKeyAlgorithms ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa
        Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
        MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com
        
        # Connection settings
        ServerAliveInterval 60
        ServerAliveCountMax 3
        TCPKeepAlive yes
        
        # Security settings
        HashKnownHosts yes
        VisualHostKey yes
        AddKeysToAgent yes
        
        # Performance settings
        Compression yes
        ControlMaster auto
        ControlPath ~/.ssh/master-%r@%h:%p
        ControlPersist 10m
    '';
    
    # Common host configurations
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      
      # Example for personal servers
      # "myserver" = {
      #   hostname = "example.com";
      #   user = "brandon";
      #   port = 22;
      #   identityFile = "~/.ssh/id_ed25519";
      # };
    };
  };
  
  # SSH agent service
  services.ssh-agent.enable = true;
  
  # Create SSH directory and set permissions
  home.file.".ssh/.keep" = {
    text = "";
    target = ".ssh/.keep";
  };
  
  home.activation.setupSshPermissions = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      if [ -d "$HOME/.ssh" ]; then
        chmod 700 "$HOME/.ssh"
        chmod 644 "$HOME/.ssh"/*.pub 2>/dev/null || true
        chmod 600 "$HOME/.ssh"/id_* 2>/dev/null || true
        chmod 600 "$HOME/.ssh"/config 2>/dev/null || true
        chmod 600 "$HOME/.ssh"/known_hosts* 2>/dev/null || true
      fi
    '';
  };
  
  # Useful SSH-related packages
  home.packages = with pkgs; [
    openssh
    ssh-copy-id
    ssh-audit
  ];
}