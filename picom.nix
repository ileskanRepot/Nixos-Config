{ config, options, lib, pkgs, ... }:
{
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.8;
    backend = "glx";
    settings = {
      focus-exclude = [
        "class_g = 'Cairo-clock'"
        "!I3_FLOATING_WINDOW@:c"
      ];
    };
  };
}
