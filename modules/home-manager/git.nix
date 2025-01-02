{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Brandon Nesbitt";
    userEmail = "brandon.nesbitt@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
