{ config, pkgs, ...}:
{
  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      --audio-format mp3
    '';
  };
}
