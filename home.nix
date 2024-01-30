{config, pkgs, ...}:
{
  imports = [
    ./secret.nix
    ./i3.nix
    ./bash.nix
    ./nvim.nix
    ./chromium.nix
    ./dunst.nix
    ./i3rust.nix
    ./htop.nix
    ./mpv.nix
    ./code.nix
    ./zathura.nix
    ./yt-dlp.nix
    ./picom.nix

#    ./vim.nix
#    ./vscodium.nix
#    ./cursor.nix
#    ./firefox.nix
#    ./astroNvim.nix
  ];
  home.stateVersion = "22.11";
  home.username = "ileska";
  home.homeDirectory = "/home/ileska";
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
  # Temporaly for C course
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
}
