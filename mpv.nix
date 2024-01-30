{ config, pkgs, ...}:
{
  programs.mpv = {
    enable = true;
    # scripts =[ mpvScripts.mpris ];

  };
  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ self.mpvScripts.mpris ];
      };
    })
  ];
}
