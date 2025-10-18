{ pkgs, ... }:

{
  programs.k9s = {
    enable = true;

    # Set default settings for k9s
    settings = {
      k9s = {
        # Use live data refresh
        liveViewAutoRefresh = true;
        # Refresh rate in seconds
        refreshRate = 2;
        # Max number of items to keep in logs
        maxConnRetry = 5;
        # Read-only mode
        readOnly = false;
        # No exit on error
        noExitOnCtrlC = false;
        # UI settings
        ui = {
          enableMouse = false;
          headless = false;
          logoless = false;
          crumbsless = false;
          reactive = false;
          noIcons = false;
          skin = "nord";
        };
        # Skip latest rev check
        skipLatestRevCheck = false;
        # Disable pod metrics
        disablePodCounting = false;
        # Shell pod configuration
        shellPod = {
          image = "busybox:1.35.0";
          namespace = "default";
          limits = {
            cpu = "100m";
            memory = "100Mi";
          };
        };
        # Image scan configuration
        imageScans = {
          enable = false;
          exclusions = {
            namespaces = [];
            labels = {};
          };
        };
        # Logger configuration
        logger = {
          tail = 100;
          buffer = 5000;
          sinceSeconds = -1;
          textWrap = false;
          showTime = false;
        };
        # Threshold configuration
        thresholds = {
          cpu = {
            critical = 90;
            warn = 70;
          };
          memory = {
            critical = 90;
            warn = 70;
          };
        };
      };
    };

    # Skins (themes) configuration
    skins = {
      # Nord theme configuration
      nord = {
        k9s = {
          # Body styles
          body = {
            fgColor = "#d8dee9";
            bgColor = "#2e3440";
            logoColor = "#5e81ac";
          };
          
          # Prompt styles
          prompt = {
            fgColor = "#d8dee9";
            bgColor = "#2e3440";
            suggestColor = "#5e81ac";
          };
          
          # Info section
          info = {
            fgColor = "#88c0d0";
            sectionColor = "#81a1c1";
          };
          
          # Dialog styles
          dialog = {
            fgColor = "#d8dee9";
            bgColor = "#2e3440";
            buttonFgColor = "#2e3440";
            buttonBgColor = "#88c0d0";
            buttonFocusFgColor = "#2e3440";
            buttonFocusBgColor = "#81a1c1";
            labelFgColor = "#a3be8c";
            fieldFgColor = "#d8dee9";
          };
          
          # Frame styles
          frame = {
            border = {
              fgColor = "#4c566a";
              focusColor = "#5e81ac";
            };
            menu = {
              fgColor = "#d8dee9";
              keyColor = "#88c0d0";
              numKeyColor = "#81a1c1";
            };
            crumbs = {
              fgColor = "#d8dee9";
              bgColor = "#3b4252";
              activeColor = "#88c0d0";
            };
            status = {
              newColor = "#a3be8c";
              modifyColor = "#ebcb8b";
              addColor = "#88c0d0";
              errorColor = "#bf616a";
              highlightColor = "#5e81ac";
              killColor = "#d08770";
              completedColor = "#4c566a";
            };
            title = {
              fgColor = "#d8dee9";
              bgColor = "#3b4252";
              highlightColor = "#88c0d0";
              counterColor = "#81a1c1";
              filterColor = "#a3be8c";
            };
          };
          
          # Views styles
          views = {
            charts = {
              bgColor = "default";
              defaultDialColors = [
                "#5e81ac"
                "#bf616a"
                "#a3be8c"
                "#ebcb8b"
                "#d08770"
                "#b48ead"
                "#88c0d0"
              ];
              defaultChartColors = [
                "#5e81ac"
                "#bf616a"
                "#a3be8c"
                "#ebcb8b"
                "#d08770"
                "#b48ead"
                "#88c0d0"
              ];
            };
            
            table = {
              fgColor = "#d8dee9";
              bgColor = "#2e3440";
              cursorFgColor = "#2e3440";
              cursorBgColor = "#88c0d0";
              markColor = "#ebcb8b";
              header = {
                fgColor = "#d8dee9";
                bgColor = "#3b4252";
                sorterColor = "#88c0d0";
              };
            };
            
            xray = {
              fgColor = "#d8dee9";
              bgColor = "#2e3440";
              cursorColor = "#88c0d0";
              graphicColor = "#5e81ac";
              showIcons = false;
            };
            
            yaml = {
              keyColor = "#5e81ac";
              colonColor = "#4c566a";
              valueColor = "#d8dee9";
            };
            
            logs = {
              fgColor = "#d8dee9";
              bgColor = "#2e3440";
              indicator = {
                fgColor = "#88c0d0";
                bgColor = "#3b4252";
                toggleOnColor = "#a3be8c";
                toggleOffColor = "#4c566a";
              };
            };
          };
        };
      };
    };
  };
}
