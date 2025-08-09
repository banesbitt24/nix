{ pkgs, ... }:

{
  programs.k9s = {
    enable = true;
    
    # Hotkeys configuration
    hotkey = {
      # Custom hotkeys for better workflow
      hotKey = {
        shift-0 = {
          shortCut = "Shift-0";
          description = "Viewing pods";
          command = "pods";
        };
        shift-1 = {
          shortCut = "Shift-1";
          description = "Viewing deployments";
          command = "deployments";
        };
        shift-2 = {
          shortCut = "Shift-2";
          description = "Viewing services";
          command = "services";
        };
        shift-3 = {
          shortCut = "Shift-3";
          description = "Viewing configmaps";
          command = "configmaps";
        };
        shift-4 = {
          shortCut = "Shift-4";
          description = "Viewing secrets";
          command = "secrets";
        };
        shift-5 = {
          shortCut = "Shift-5";
          description = "Viewing nodes";
          command = "nodes";
        };
      };
    };
    
    # Aliases for common resources
    aliases = {
      alias = {
        dp = "v1/deployments";
        sec = "v1/secrets";
        jo = "batch/v1/jobs";
        cr = "rbac.authorization.k8s.io/v1/clusterroles";
        crb = "rbac.authorization.k8s.io/v1/clusterrolebindings";
        ro = "rbac.authorization.k8s.io/v1/roles";
        rb = "rbac.authorization.k8s.io/v1/rolebindings";
        np = "networking.k8s.io/v1/networkpolicies";
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