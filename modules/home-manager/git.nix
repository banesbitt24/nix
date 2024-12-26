{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Brandon Nesbitt";
    userEmail = "brandon.nesbitt@fastmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
