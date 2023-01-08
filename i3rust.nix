{ config, pkgs, ...}:
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        blocks = [
         {
           block = "battery";
           format = "{percentage}";
           interval = 1;
         }
         {
           block = "sound";
         }
         {
           block = "memory";
           interval = 1;
           display_type = "memory";
           format_mem = "{mem_used_percents}";
           format_swap = "{swap_used_percents}";
         }
         {
           block = "cpu";
           interval = 1;
         }
         {
           block = "time";
           interval = 1;
           format = "%d/%m %H:%M:%S";
         }
        ];
      };
    };
  };
}
