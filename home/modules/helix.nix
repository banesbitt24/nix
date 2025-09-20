{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "nord";
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt-rfc-style";
          };
        }
      ];
      language-server.nil = {
        command = "nil";
      };
    };
  };
}
