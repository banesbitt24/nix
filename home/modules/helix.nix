{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "nord";
    };
    languages = {
      language-server = {
        nil = {
          command = "nil";
        };
        gopls = {
          command = "gopls";
          config = {
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
        rust-analyzer = {
          command = "rust-analyzer";
          config = {
            check = {
              command = "clippy";
            };
            inlayHints = {
              bindingModeHints.enable = false;
              closingBraceHints.minLines = 10;
              closureReturnTypeHints.enable = "with_block";
              discriminantHints.enable = "fieldless";
              lifetimeElisionHints.enable = "skip_trivial";
              typeHints.hideClosureInitialization = false;
            };
          };
        };
        terraform-ls = {
          command = "terraform-ls";
          args = ["serve"];
        };
      };
    };
  };

  # Install language tools
  home.packages = with pkgs; [
    # Go
    go
    gopls
    gotools  # includes goimports

    # Rust (rustup manages rust-analyzer, rustc, cargo, etc.)
    rustup

    # Terraform/Terragrunt
    terraform
    terragrunt
    terraform-ls
  ];
}
