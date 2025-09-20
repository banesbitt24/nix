# btop.nix - System monitor with Nord theme
{ config, pkgs, ... }:

{
  programs.btop = {
    enable = true;
    
    settings = {
      # Color theme - Nord
      color_theme = "nord";
      
      # General settings
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      
      # Update intervals
      update_ms = 2000;
      proc_update_mult = 2;
      
      # UI settings
      proc_tree = false;
      proc_colors = true;
      proc_gradient = false;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      
      # CPU settings
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      
      # Memory settings
      mem_graphs = true;
      mem_below_net = false;
      
      # Network settings
      net_download = " ↓";
      net_upload = " ↑";
      net_auto = true;
      net_sync = true;
      net_iface = "";
      
      # Disk settings
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      zfs_arc_cached = true;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";
      
      # Temperature settings
      check_temp = true;
      show_coretemp = true;
      temp_scale = "celsius";
      base_10_sizes = false;
      
      # Background and transparency
      background_update = true;
      custom_cpu_name = "";
      disks_filter = "";
      mem_cached = true;
      mem_available = true;
      mem_buffers = true;
      
      # Process filtering
      proc_filtering = true;
      proc_aggregated = false;
      proc_fold = false;
      proc_filter_kernel = false;
    };
  };
}