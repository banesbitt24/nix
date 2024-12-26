{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      vim = "nvim";
    };
  };
}
