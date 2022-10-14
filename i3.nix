# Example config https://github.com/disassembler/nixos-configurations/blob/master/modules/profiles/i3.nix
{ pkgs, lib, ... }:
let 
  i3Lock = pkgs.writeScript "i3-lock.sh" ''
    #!${pkgs.bash}/bin/bash
    DUNST_STATUS=$(dunstctl is-paused)
    dunstctl set-paused true
    i3-msg "bar mode invisible"
    ${pkgs.i3lock-color}/bin/i3lock-color -n -f \
      -c 000000 \
      --pass-power-keys
    i3-msg "bar mode hide"
    [ "$DUNST_STATUS" == "false" ] && dunstctl set-paused false
  '';
  clipQalc = pkgs.writeScript "clipQalc.sh" ''
    #!${pkgs.bash}/bin/bash
    qalc -s 'angle 0' -s 'angle degrees' -s 'color false' -s 'decimal comma on' -t "$(xclip -selection c -o | sed 's/bar//g' | sed 's/{/(/g' | sed 's/%pi/π/g' |sed 's/}/\)/g' | sed 's#cdot#*#g' | sed 's#over#/#g' | tr -d " ")" | tr -d "\n" | xclip -selection c -i
  '';
  DcTgJson = pkgs.writeScript "DcTg.json" '' {
  "border": "none",
  "floating": "auto_off",
  "layout": "splitv",
  "marks": [],
  "percent": 0.5,
  "type": "con",
  "nodes": [
    {
      "border": "none",
      "current_border_width": 0,
      "floating": "auto_off",
      "geometry": {
        "height": 1060,
        "width": 945,
        "x": 10,
        "y": 10
      },
      "marks": [],
      "name": "Discord",
      "percent": 0.5,
      "swallows": [
        {
          "class": "^Chromium\\-browser$",
          "instance": "^discord\\.com__app$",
          "machine": "^pahvi$",
          "title": "^Discord$",
          "window_role": "^pop\\-up$"
        }
      ],
      "type": "con"
    },
    {
      "border": "none",
      "current_border_width": 0,
      "floating": "auto_off",
      "geometry": {
        "height": 1060,
        "width": 945,
        "x": 10,
        "y": 10
      },
      "marks": [],
      "name": "Telegram Web",
      "percent": 0.5,
      "swallows": [
        {
          "class": "^Chromium\\-browser$",
          "instance": "^web\\.telegram\\.org$",
          "machine": "^pahvi$",
          "title": "^Telegram\\ Web$",
          "window_role": "^pop\\-up$"
        }
      ],
      "type": "con"
    }
  ]
}
{
  "border": "none",
  "floating": "auto_off",
  "layout": "splitv",
  "marks": [],
  "percent": 0.5,
  "type": "con",
  "nodes": [
    {
      "border": "none",
      "current_border_width": 0,
      "floating": "auto_off",
      "geometry": {
        "height": 1080,
        "width": 640,
        "x": 1280,
        "y": 0
      },
      "marks": [],
      "name": "YouTube Music - Chromium",
      "percent": 0.5,
      "swallows": [
        {
          "class": "^Chromium\\-browser$",
          "instance": "^chromium\\-browser$",
          "machine": "^pahvi$",
          "title": "^YouTube\\ Music\\ \\-\\ Chromium$",
          "window_role": "^browser$"
        }
      ],
      "type": "con"
    },
    {
      "border": "none",
      "current_border_width": 0,
      "floating": "auto_off",
      "geometry": {
         "height": 340,
         "width": 564,
         "x": 0,
         "y": 0
      },
      "marks": [],
      "name": "st",
      "percent": 0.5,
      "swallows": [
        {
          "class": "^st\\-256color$",
          "instance": "^st\\-256color$",
          "machine": "^pahvi$",
          "title": "^st$"
        }
      ],
      "type": "con"
    }
  ]
}
  '';
  DcTg = pkgs.writeScript "DcTg.sh" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.i3}/bin/i3-msg "workspace DcTg"
    ${pkgs.i3}/bin/i3-msg "append_layout ${DcTgJson}"
    ${pkgs.chromium}/bin/chromium --new-window --app=https://discord.com/app & disown
    ${pkgs.chromium}/bin/chromium --new-window --app=https://web.telegram.org & disown
    ${pkgs.chromium}/bin/chromium --new-window https://music.youtube.com & disown
    ${pkgs.st}/bin/st
  '';

  DmenuColors = pkgs.writeText "DmenuColors" ''-sb #af00af -nb #000000'';
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
        "${modifier}+r" = "exec dmenu_run $(cat ${DmenuColors})";
        "${modifier}+q" = "exec librewolf";
        "${modifier}+y" = "mode resize";
        "${modifier}+Tab" = "workspace back_and_forth";
        "${modifier}+x" = "[urgent=latest] focus";
        "${modifier}+Shift+s" = "exec ${DcTg}";
        "${modifier}+minus" = "workspace DcTg";
        "${modifier}+XF86PowerOff" = "exec systemctl hibernate";
        "${modifier}+t" = "fullscreen toggle";
        "${modifier}+F9" = "exec playerctl previous";
        "${modifier}+F10" = "exec playerctl play-pause";
        "${modifier}+F11" = "exec playerctl next";
        "${modifier}+Shift+F9" = "exec playerctl -p $(playerctl --list-all | dmenu $(cat ${DmenuColors})) previous";
        "${modifier}+Shift+F10" = "exec playerctl -p $(playerctl --list-all | dmenu $(cat ${DmenuColors})) play-pause";
        "${modifier}+Shift+F11" = "exec playerctl -p $(playerctl --list-all | dmenu $(cat ${DmenuColors})) next";
        "${modifier}+semicolon" = "exec mpv --input-ipc-server=/tmp/mpvsocket --hwdec=auto \"$(${pkgs.xclip}/bin/xclip -o)\" --really-quiet";
        "XF86Calculator" = "exec ${clipQalc}";
        "Control+space" = "exec dunstctl close";
        "Control+." = "exec dunstctl history-pop";
        "Print" = "exec maim -s --format png /dev/stdout | xclip -selection clipboard -t image/png -i";
        "XF86PowerOff" = "exec ${i3Lock}";

      };
      # Bar is off cause I didn't know how to color my bar in nix. Bar is defined in extraConfig
      bars = [ ];
      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ~/Downloads/black.png";
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
          "e" = "resize grow height 10 px or 10 ppt";
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
bar {
  i3bar_command   i3bar -t
  status_command  i3status
  position        top
  mode            hide
  colors {
    background #000000
    separator #E754E0
    # colorclass       <border> <background> <text>
    inactive_workspace #E754E0  #E754E0     #000000
    focused_workspace  #E754E0  #000000     #E754E0
  }
}
    '';
  };
}
