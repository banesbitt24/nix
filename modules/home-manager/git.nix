{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Brandon Nesbitt";
    userEmail = "bnesbitt24@icloud.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
