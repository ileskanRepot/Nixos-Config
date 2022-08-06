{config, pkgs, ...}:
{
  imports = [
    ./secret.nix
    ./i3.nix
    ./bash.nix
    ./vim.nix
    ./chromium.nix
#    ./firefox.nix
  ];
  home.sessionVariables = {
    EDITOR = "vim";
    NIX_SHELL_PRESERVE_PROMPT=1;
  };
}
