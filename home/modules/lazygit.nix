{ config, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      # Nord theme colors
      gui = {
        theme = {
          selectedLineBgColor = ["#5e81ac"];
          selectedRangeBgColor = ["#5e81ac"];
          cherryPickedCommitBgColor = ["#a3be8c"];
          cherryPickedCommitFgColor = ["#2e3440"];
          unstagedChangesColor = ["#d08770"];
          defaultFgColor = ["#eceff4"];
        };
        authorColors = {
          "*" = "#88c0d0";
        };
        branchColors = {
          "master" = "#bf616a";
          "main" = "#bf616a";
          "develop" = "#a3be8c";
          "feature/*" = "#ebcb8b";
          "hotfix/*" = "#d08770";
          "release/*" = "#b48ead";
        };
      };
      # Git configuration
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        merging = {
          manualCommit = false;
          args = "";
        };
      };
      # UI preferences
      refresher = {
        refreshInterval = 10;
        fetchInterval = 60;
      };
      update = {
        method = "prompt";
      };
    };
  };
}