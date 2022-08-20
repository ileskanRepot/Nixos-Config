{config, pkgs, ...}:
{
  imports = [
    ./secret.nix
    ./i3.nix
    ./bash.nix
#    ./vim.nix
    ./nvim.nix
    ./chromium.nix
#    ./firefox.nix
#    ./dunst.nix
    ./htop.nix
  ];
  home.sessionVariables = {
    EDITOR = "vim";
    NIX_SHELL_PRESERVE_PROMPT=1;
  };
}
