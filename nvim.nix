{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
      set langremap
      nnoremap \ :set nu! rnu!<Return>
      highlight LineNr ctermfg=13 ctermbg=0
      highlight Search ctermfg=0 ctermbg=13
      highlight NonText ctermfg=5
      set hlsearch
      set tabstop=2
      set shiftwidth=2
    '';
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };
}
