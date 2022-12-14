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
    ./dunst.nix
#    ./cursor.nix
    ./htop.nix
    ./mpv.nix
  ];
  home.sessionVariables = {
    EDITOR = "vim";
    NIX_SHELL_PRESERVE_PROMPT=1;
  };
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["zathura.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["zathura.desktop"];
    };
  };
}
