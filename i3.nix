# Example config https://github.com/disassembler/nixos-configurations/blob/master/modules/profiles/i3.nix
{ pkgs, lib, ... }:
let 
  i3Lock = pkgs.writeScript "i3-lock.sh" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.i3lock-color}/bin/i3lock-color -f \
      -i ~/Downloads/linu.pic
  '';
in {
  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      modifier = "Mod4";

      window = {
        border = 0;
      };

      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 1%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 1%+";
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "${modifier}+BackSpace" = "exec /run/current-system/sw/bin/st";
        "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${modifier}+Shift+x" = "exec systemctl suspend";
        "${modifier}+Shift+c" = "reload";
        # "${modifier}+Escape" = "exec ${i3Lock} && exec firefox";
        "${modifier}+Escape" = "exec ${i3Lock}";
        "${modifier}+n" = "focus down";
        "${modifier}+e" = "focus up";
        "${modifier}+i" = "focus right";
        "${modifier}+h" = "focus left";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+n" = "move down";
        "${modifier}+Shift+e" = "move up";
        "${modifier}+Shift+i" = "move right";
        "${modifier}+f" = "layout toggle split";
        "${modifier}+p" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${modifier}+r" = "exec dmenu_run -sb \"#af00af\" -nb \"#000000\"";
        "${modifier}+q" = "exec firefox";
        "${modifier}+y" = "mode resize";
        "Print" = "exec maim -s --format png /dev/stdout | xclip -selection clipboard -t image/png -i";
      };
      bars = [ ];
      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ~/Downloads/linu.pic";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.alsa-utils}/bin/amixer set Master 0%";
        }
        {
          command = "${pkgs.i3}/bin/i3-msg workspace 1";
        }
        #{
        #  command = "";
        #}
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
    extraConfig = ''default_border none
bar {
  i3bar_command   i3bar -t
  status_command  i3status
  position        top
  mode            hide
  colors {
    background #000000
    separator #1ABC9C
    # colorclass       <border> <background> <text>
    inactive_workspace #E754E0  #E754E0     #000000
    focused_workspace  #E754E0  #000000     #E754E0
  }
}
    '';
  };
}
