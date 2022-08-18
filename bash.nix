{ config, pkgs, ...}:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      la = "ls -a";
      ll = "ls -lhA";
      pclip = "xclip -o -selection clipboard";
      cclip = "xclip -i -selection clipboard";
      cpwd = "pwd | tr -d \"\n\" | xclip -selection clipboard";
      ".." = "cd ..";
      ".2" = "cd ../..";
      ".3" = "cd ../../..";
      pcd = "cd $(xclip -o -selection clipboard)";
      grep = "grep --color=auto";
      ssh = "TERM=xterm ssh";
      evo = "TERM=xterm ssh aksleino@evo.paivola.fi";
      screenshot = "maim -s --format png /dev/stdout | xclip -selection clipboard -t image/png -i";
      GITLABPSW="export CI_REGISTRY_PASSWORD=$(pass show gitlab/registry)";
      gs="git status";
      gd="git diff";
      ga="git add";
      gc="git commit";
      vimtmp="vim /tmp/$RANDOM";
      open="xdg-open";
      vim="nvim";
    };
    historyControl = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];
    initExtra = ''
      PS1="\[\033[95m\]\W λ\[\033[0m\] "
      cd() { builtin cd "$@" && echo -en "\033]0;$(pwd | sed "s#$HOME#~#g")\a" && ls ; }
      printf '\033[?1h\033=' >/dev/tty
      export EDITOR=vim
    '';
  };
}
