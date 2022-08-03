{ pkgs, lib, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      modifier = "Mod4";
      bars = [ ];

      window.border = 0;

      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 1%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 1%+";
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "${modifier}+BackSpace" = "exec ${pkgs.st}/bin/st";
        "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${modifier}+Shift+x" = "exec systemctl suspend";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+minus" = "exec i3lock";
        "${modifier}+h" = "focus left";
        "${modifier}+n" = "focus down";
        "${modifier}+e" = "focus up";
        "${modifier}+i" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+n" = "move down";
        "${modifier}+Shift+e" = "move up";
        "${modifier}+Shift+i" = "move right";
        "${modifier}+f" = "layout toggle split";
        "${modifier}+p" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${modifier}+r" = "exec dmenu_run -sb \"#af00af\" -nb \"#000000\"";
        "${modifier}+q" = "exec firefox";
        "${modifier}+y" = "mode resize";
      };
      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ~/background.png";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.alsa-utils}/bin/amixer set Master 0%";
        }
        {
          command = "${pkgs.i3}/bin/i3-msg workspace 1";
        }
      ];
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "n" = "resize shrink height 10 px or 10 ppt";
          "e" = "resize grow width 10 px or 10 ppt";
          "i" = "resize grow width 10 px or 10 ppt";
          "shift+h" = "resize shrink width 1 px or 1 ppt";
          "shift+n" = "resize shrink height 1 px or 1 ppt";
          "shift+e" = "resize grow width 1 px or 1 ppt";
          "shift+i" = "resize grow width 1 px or 1 ppt";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
    extraConfig = ''
      default_border none
    '';
  };
}
