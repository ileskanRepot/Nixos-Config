# Example config https://github.com/disassembler/nixos-configurations/blob/master/modules/profiles/i3.nix
{ pkgs, lib, ... }:
let 
  changeMonitors = pkgs.writeScript "changeMonitors.sh" ''
    #!${pkgs.bash}/bin/bash
    monitors=$(${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | grep DP-2)
    # echo $monitors
    if [ -z "$monitors" ]
    then
	    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --same-as HDMI-1 --auto
	    ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --off
    else
	    ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --same-as DP-2 --auto
	    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --off
    fi
  '';
  i3Lock = pkgs.writeScript "i3-lock.sh" ''
    #!${pkgs.bash}/bin/bash
    DUNST_STATUS=$(dunstctl is-paused)
    dunstctl set-paused true
    i3-msg "bar mode invisible"
    ${pkgs.i3lock-color}/bin/i3lock-color -k -n -f \
      -i ~/.config/nixpkgs/pinguInvert.png \
      --pass-power-keys \
      --inside-color=00000000 --insidever-color=00000000 --insidewrong-color=00000000 \
      --ring-color=ff00ffff
    i3-msg "bar mode hide"
    [ "$DUNST_STATUS" == "false" ] && dunstctl set-paused false
  '';
  clipQalc = pkgs.writeScript "clipQalc.sh" ''
    #!${pkgs.bash}/bin/bash
    qalc -s 'angle 0' -s 'angle degrees' -s 'color false' -s 'decimal comma on' -t "$(xclip -selection c -o | sed 's/bar//g' | sed 's/{/(/g' | sed 's/%pi/π/g' |sed 's/}/\)/g' | sed 's#cdot#*#g' | sed 's#over#/#g' | tr -d " ")" | tr -d "\n" | xclip -selection c -i
  '';
  DcTgJson = pkgs.writeScript "DcTg.json" ''
  [{
	"border": "none",
	"floating": "auto_off",
	"layout": "splitv",
	"marks": [],
	"percent": 0.5,
	"type": "con",
	"nodes": [
		{
			"border": "pixel",
			"current_border_width": 1,
			"floating": "auto_off",
			"geometry": {
			   "height": 1060,
			   "width": 945,
			   "x": 10,
			   "y": 10
			},
			"marks": [],
			"name": "Telegram",
			"percent": 0.5,
			"swallows": [
			   {
			   "class": "^Google\\-chrome$",
			   "instance": "^web\\.telegram\\.org$",
			   "machine": "^pahvi$",
			   "title": "^Telegram$",
			   "window_role": "^pop\\-up$"
			   }
			],
			"type": "con"
		},
		{
			"border": "pixel",
			"current_border_width": 1,
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
			   "class": "^Google\\-chrome$",
			   "instance": "^discord\\.com__app$",
			   "machine": "^pahvi$",
			   "title": "^Discord$",
			   "window_role": "^pop\\-up$"
			   }
			],
			"type": "con"
		}
	]
},

{
	"border": "pixel",
	"floating": "auto_off",
	"layout": "splitv",
	"marks": [],
	"percent": 0.5,
	"type": "con",
	"nodes": [
		{
			"border": "pixel",
			"current_border_width": 1,
			"floating": "auto_off",
			"geometry": {
			   "height": 1079,
			   "width": 1919,
			   "x": 0,
			   "y": 0
			},
			"marks": [],
			"name": "YouTube Music - Google Chrome",
			"percent": 0.5,
			"swallows": [
			   {
			   "class": "^Google\\-chrome$",
			   "instance": "^google\\-chrome$",
			   "machine": "^pahvi$",
			   "title": "^YouTube\\ Music\\ \\-\\ Google\\ Chrome$",
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
}]
  '';
  DcTg = pkgs.writeScript "DcTg.sh" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.i3}/bin/i3-msg "workspace DcTg"
    ${pkgs.i3}/bin/i3-msg "append_layout ${DcTgJson}"
    ${pkgs.google-chrome}/bin/google-chrome-stable --disable-gpu-driver-bug-workarounds --new-window --app=https://discord.com/app & disown
    ${pkgs.google-chrome}/bin/google-chrome-stable --disable-gpu-driver-bug-workarounds --new-window --app=https://web.telegram.org & disown
    ${pkgs.google-chrome}/bin/google-chrome-stable --disable-gpu-driver-bug-workarounds --new-window https://music.youtube.com & disown
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
        "XF86MonBrightnessDown" = "exec light -T 0.9";
        "XF86MonBrightnessUp" = "exec light -T 1.1";
        "${modifier}+BackSpace" = "exec /run/current-system/sw/bin/st";
        "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${modifier}+Shift+x" = "exec systemctl suspend";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Escape" = "exec ${i3Lock}";
        "${modifier}+Shift+ctrl+d" = "exec ${changeMonitors}";
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
        "${modifier}+q" = "exec env MOZ_USE_XINPUT2=1 librewolf";
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
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "${modifier}+Shift+F9" = "exec playerctl -p $(playerctl --list-all | dmenu $(cat ${DmenuColors})) previous";
        "${modifier}+Shift+F10" = "exec playerctl -p $(playerctl --list-all | dmenu $(cat ${DmenuColors})) play-pause";
        "${modifier}+Shift+F11" = "exec playerctl -p $(playerctl --list-all | dmenu $(cat ${DmenuColors})) next";
        "${modifier}+semicolon" = "exec mpv --input-ipc-server=/tmp/mpvsocket --hwdec=auto \"$(${pkgs.xclip}/bin/xclip -o)\" --really-quiet";
        "${modifier}+bracketleft" = "exec --no-startup-id notify-send 'MUSIC' \"$(playerctl -a metadata --format '{{ uc(playerName) }} - {{ status }}: {{ title }}')\"";
        "${modifier}+bracketright" = "exec --no-startup-id fullscreen disable; floating enable; resize set 480 270; sticky enable; move window to position 1435 0";
        "${modifier}+ctrl+h" = "move workspace to output left";
        "${modifier}+ctrl+i" = "move workspace to output right";
        "XF86Calculator" = "exec ${clipQalc}";
        "Control+comma" = "exec dunstctl close";
        "Control+period" = "exec dunstctl history-pop";
        # "Print" = "exec maim -su --format png /dev/stdout | xclip -selection clipboard -t image/png -i";
        "Print" = "exec flameshot gui";
        "${modifier}+Print" = "exec flameshot gui --raw | tesseract stdin stdout | xclip -in -selection clipboard && notify-send \"$(xclip -o -selection clipboard)\"";
        "XF86PowerOff" = "exec ${i3Lock}";
        "${modifier}+Shift+minus" = "move container to workspace DcTg";
        "${modifier}+d" = "exec google-chrome-stable";
      };
      # Bar is off cause I didn't know how to color my bar in nix. Bar is defined in extraConfig
      bars = [ ];
      startup = [
        {
          command = "${pkgs.alsa-utils}/bin/amixer set Master 0%";
        }
        {
          command = "${pkgs.i3}/bin/i3-msg workspace 1";
        }
        {
          command = "${pkgs.flameshot}/bin/i3-msg workspace 1";
        }
        {
          command = "${pkgs.kdeconnect}/bin/kdeconnect-indicator";
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
# class                 border  backgr. text    indicator child_border
client.focused          #000000 #dd00dd #ffffff #ff00ff   #ff00ff
client.focused_inactive #333333 #660066 #ffffff #484e50   #000000
client.unfocused        #440044 #220022 #888888 #292d2e   #000000
client.urgent           #2f343a #900000 #ffffff #900000   #900000
client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c
client.background       #ffffff

default_border pixel 1
hide_edge_borders both
bar {
  i3bar_command   i3bar -t
  status_command  i3status-rs ~/.config/i3status-rust/config-top.toml
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
