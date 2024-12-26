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
        "rust"
        "tailscale"
      ];
      theme = "powerlevel10k";
    };
    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      vim = "nvim";
    };
  };
}
