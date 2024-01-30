{ config, pkgs, ...}:
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        blocks = [
         {
           block = "battery";
           device = "BAT0";
           interval = 1;
           format = "{percentage}";
         }
         {
           alert = 10.0;
           block = "disk_space";
           info_type = "available";
           interval = 60;
           path = "/";
           warning = 20.0;
         }
         {
           block = "sound";
         }
         {
           block = "memory";
           format = " $icon $mem_total_used_percents.eng(w:2) ";
           format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
         }
         {
           block = "cpu";
           interval = 1;
         }
         {
           block = "time";
           interval = 1;
           format = "$timestamp.datetime(f:'%d/%m %H:%M:%S')";
         }
        ];
      };
    };
  };
}
