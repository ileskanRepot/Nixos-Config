{ pkgs, ... }:
{
  services.dunst = {
    enable = true;

    settings = rec {
      frame = {
        color = "#ff00ff";

        width = 2;
      };

      global = {
        # Alignment of message text.
        # Possible values are "left", "center" and "right".
        alignment = "left";

        allow_markup = true;

        # The frequency with wich text that is longer than the notification
        # window allows bounces back and forth.
        # This option conflicts with "word_wrap".
        # Set to 0 to disable.
        bounce_freq = 0;

        # Browser for opening urls in context menu.
        browser = "librewolf";

        # Display notification on focused monitor.  Possible modes are:
        #   mouse: follow mouse pointer
        #   keyboard: follow window with keyboard focus
        #   none: don't follow anything
        #
        # "keyboard" needs a windowmanager that exports the
        # _NET_ACTIVE_WINDOW property.
        # This should be the case for almost all modern windowmanagers.
        #
        # If this option is set to mouse or keyboard, the monitor option
        # will be ignored.
        follow = "keyboard";

        font = "Open Sans 8";

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        # Markup is allowed
        format = ''<b>%a</b>: %s %p\n%b'';

        corner_radius = 7;

        # The geometry of the window:
        #   [{width}]x{height}[+/-{x}+/-{y}]
        # The geometry of the message window.
        # The height is measured in number of notifications everything else
        # in pixels.  If the width is omitted but the height is given
        # ("-geometry x2"), the message window expands over the whole screen
        # (dmenu-like).  If width is 0, the window expands to the longest
        # message displayed.  A positive x is measured from the left, a
        # negative from the right side of the screen.  Y is measured from
        # the top and down respectevly.
        # The width can be negative.  In this case the actual width is the
        # screen width minus the width defined in within the geometry option.
        # geometry = "0x4-100+100";
        width = 300;
        height = 300;
        offset = "5x5";

        # Maximum amount of notifications kept in history
        history_length = 50;

        # Horizontal padding.
        horizontal_padding = 10;

        # Align icons left/right/off
        icon_position = "left";

        # Don't remove messages, if the user is idle (no mouse or keyboard input)
        # for longer than idle_threshold seconds.
        # Set to 0 to disable.
        # default 120
        idle_threshold = 120;

        # Show how many messages are currently hidden (because of geometry).
        indicate_hidden = true;

        # Ignore newlines '\n' in notifications.
        ignore_newline = false;

        # The height of a single line.  If the height is smaller than the
        # font height, it will get raised to the font height.
        # This adds empty space above and under the text.
        line_height = 0;

        # Padding between text and separator.
        padding = 8;

        # Define a color for the separator.
        # possible values are:
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        frame_color = "#ff00ff";
        separator_color = "frame";

        # Draw a line of "separator_height" pixel height between two
        # notifications.
        # Set to 0 to disable.
        separator_height = 2;

        # Show age of message if message is older than show_age_threshold
        # seconds.
        # Set to -1 to disable.
        show_age_threshold = 60;

        # Display indicators for URLs (U) and actions (A).
        show_indicators = true;

        # Shrink window if it's smaller than the width.  Will be ignored if
        # width is 0.
        shrink = true;

        # Sort messages by urgency.
        sort = true;

        # Print a notification on startup.
        # This is mainly for error detection, since dbus (re-)starts dunst
        # automatically after a crash.
        startup_notification = true;

        # Should a notification popped up from history be sticky or timeout
        # as if it would normally do.
        sticky_history = true;

        # The transparency of the window.  Range: [0; 100].
        # This option will only work if a compositing windowmanager is
        # present (e.g. xcompmgr, compiz, etc.).
        transparency = 15;

        # Split notifications into multiple lines if they don't fit into
        # geometry.
        word_wrap = true;
      };

      urgency_critical = {
        background = "#ff0000";
        foreground = "#ffff00";

        timeout = 0;
      };

      urgency_low = {
        background = "#900090";
        foreground = "#ffffff";

        timeout = 10;
      };

      urgency_normal = urgency_low;
    };
  };
}
