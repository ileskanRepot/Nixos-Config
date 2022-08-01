{
  programs.bash = {
    enable = true;
    shellAliases = {
      ssh = "TERM=xterm ssh";
      grep = "grep --color=auto";
      la = "ls -a";
      pingCheck = "while ! ping -c1 luntti.net;do sleep 1;done";
      hibernate = "systemctl hibernate";
      evo = "ssh aksleino@evo.paivola.fi";
    };
    historyControl = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];
  };
}
